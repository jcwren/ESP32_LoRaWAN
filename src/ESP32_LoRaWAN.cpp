#include <ESP32_LoRaWAN.h>

#if defined (WIFI_LoRa_32) || defined (WIFI_LoRa_32_V2) 
SSD1306  Display (0x3c, SDA_OLED, SCL_OLED, RST_OLED);
#elif defined (Wireless_Stick)
SSD1306  Display (0x3c, SDA_OLED, SCL_OLED, RST_OLED, GEOMETRY_64_32);
#endif

#ifdef REGION_EU868
#include "region/RegionEU868.h"
#endif

#ifdef REGION_EU433
#include "region/RegionEU433.h"
#endif

/*!
 * Default datarate for No adr
 */
#define LORAWAN_DEFAULT_DATARATE DR_5

/*!
 * User application data size
 */
uint8_t appDataSize = 4;

/*!
 * User application data
 */
uint8_t appData[LORAWAN_APP_DATA_MAX_SIZE];


/*!
 * Defines the application data transmission duty cycle
 */
uint32_t txDutyCycleTime ;

/*!
 * Timer to handle the application data transmission duty cycle
 */
TimerEvent_t TxNextPacketTimer;

/*!
 * Indicates if a new packet can be sent
 */
static bool NextTx = true;

uint8_t ifDisplayJoined = 0;
uint8_t ifDisplayAck = 0;
enum eDeviceState deviceState;

static void lwan_dev_params_update (void);

/*!
 * \brief   Prepares the payload of the frame
 *
 * \retval  [0: frame could be send, 1: error]
 */
bool SendFrame (void)
{
  McpsReq_t mcpsReq;
  LoRaMacTxInfo_t txInfo;

  lwan_dev_params_update ();

  if (LoRaMacQueryTxPossible (appDataSize, &txInfo) != LORAMAC_STATUS_OK)
  {
    // Send empty frame in order to flush MAC commands
    mcpsReq.Type = MCPS_UNCONFIRMED;
    mcpsReq.Req.Unconfirmed.fBuffer = NULL;
    mcpsReq.Req.Unconfirmed.fBufferSize = 0;
    mcpsReq.Req.Unconfirmed.Datarate = LORAWAN_DEFAULT_DATARATE;
  }
  else
  {
    if (isTxConfirmed == true)
    {
      xprintf ("Confirmed uplink sending...\n");
      mcpsReq.Type = MCPS_CONFIRMED;
      mcpsReq.Req.Confirmed.fPort = appPort;
      mcpsReq.Req.Confirmed.fBuffer = appData;
      mcpsReq.Req.Confirmed.fBufferSize = appDataSize;
      mcpsReq.Req.Confirmed.NbTrials = confirmedNbTrials;
      mcpsReq.Req.Confirmed.Datarate = LORAWAN_DEFAULT_DATARATE;
    }
    else
    {
      xprintf ("Unconfirmed uplink sending...\n");
      mcpsReq.Type = MCPS_UNCONFIRMED;
      mcpsReq.Req.Unconfirmed.fPort = appPort;
      mcpsReq.Req.Unconfirmed.fBuffer = appData;
      mcpsReq.Req.Unconfirmed.fBufferSize = appDataSize;
      mcpsReq.Req.Unconfirmed.Datarate = LORAWAN_DEFAULT_DATARATE;
    }
  }

  if (LoRaMacMcpsRequest (&mcpsReq) == LORAMAC_STATUS_OK)
    return false;

  return true;
}

/*!
 * \brief Function executed on TxNextPacket Timeout event
 */
static void OnTxNextPacketTimerEvent (void)
{
  MibRequestConfirm_t mibReq;
  LoRaMacStatus_t status;

  TimerStop (&TxNextPacketTimer);

  mibReq.Type = MIB_NETWORK_JOINED;
  status = LoRaMacMibGetRequestConfirm (&mibReq);

  if (status == LORAMAC_STATUS_OK)
  {
    if (mibReq.Param.IsNetworkJoined == true)
    {
      deviceState = DEVICE_STATE_SEND;
      NextTx = true;
    }
    else
    {
      // Network not joined yet. Try to join again
      MlmeReq_t mlmeReq;
      mlmeReq.Type = MLME_JOIN;
      mlmeReq.Req.Join.DevEui = DevEui;
      mlmeReq.Req.Join.AppEui = AppEui;
      mlmeReq.Req.Join.AppKey = AppKey;
      mlmeReq.Req.Join.NbTrials = 1;

      if (LoRaMacMlmeRequest (&mlmeReq) == LORAMAC_STATUS_OK)
        deviceState = DEVICE_STATE_SLEEP;
      else
        deviceState = DEVICE_STATE_CYCLE;
    }
  }
}

/*!
 * \brief   MCPS-Confirm event function
 *
 * \param   [IN] mcpsConfirm - Pointer to the confirm structure,
 *               containing confirm attributes.
 */
static void McpsConfirm (McpsConfirm_t *mcpsConfirm)
{
  if (mcpsConfirm->Status == LORAMAC_EVENT_INFO_STATUS_OK)
  {
    switch (mcpsConfirm->McpsRequest)
    {
      case MCPS_UNCONFIRMED:
        {
          // Check Datarate
          // Check TxPower
        }
        break;

      case MCPS_CONFIRMED:
        {
          // Check Datarate
          // Check TxPower
          // Check AckReceived
          // Check NbTrials
        }
        break;

      case MCPS_PROPRIETARY:
        break;

      default:
        break;
    }
  }

  NextTx = true;
}

/*  get the BatteryVoltage in mV. */
uint16_t GetBatteryVoltage (void)
{
  return 0;
}

void __attribute__((weak)) downLinkDataHandle (McpsIndication_t *mcpsIndication)
{
  char buffer [64];
  size_t l = 0;

  xprintf ("+REV DATA:%s, RXSIZE %d, PORT %d\n", mcpsIndication->RxSlot?"RXWIN2":"RXWIN1", mcpsIndication->BufferSize, mcpsIndication->Port);

  l += snprintf (&buffer [l], sizeof (buffer) - l, "+REV DATA:");

  for (uint8_t i = 0; i < mcpsIndication->BufferSize; i++)
    l += snprintf (&buffer [l], sizeof (buffer) - l, "%02x", mcpsIndication->Buffer [i]);

  xprintf ("%s\n", buffer);
}

/*!
 * \brief   MCPS-Indication event function
 *
 * \param   [IN] mcpsIndication - Pointer to the indication structure,
 *               containing indication attributes.
 */
int ackrssi;
static void McpsIndication (McpsIndication_t *mcpsIndication)
{
  if (mcpsIndication->Status != LORAMAC_EVENT_INFO_STATUS_OK)
    return;

  ifDisplayAck = 1;
  ackrssi = mcpsIndication->Rssi;
  xprintf ("Receive data: rssi = %d, snr = %d, datarate = %d\n", mcpsIndication->Rssi, (int)mcpsIndication->Snr, (int)mcpsIndication->RxDatarate);
  delay (10);

  switch (mcpsIndication->McpsIndication)
  {
    case MCPS_UNCONFIRMED:
      break;

    case MCPS_CONFIRMED:
      break;

    case MCPS_PROPRIETARY:
      break;

    case MCPS_MULTICAST:
      break;

    default:
      break;
  }

  // Check Multicast
  // Check Port
  // Check Datarate
  // Check FramePending
  if (mcpsIndication->FramePending == true)
  {
    // The server signals that it has pending data to be sent.
    // We schedule an uplink as soon as possible to flush the server.
    OnTxNextPacketTimerEvent ();
  }

  // Check Buffer
  // Check BufferSize
  // Check Rssi
  // Check Snr
  // Check RxSlot
  if (mcpsIndication->RxData == true)
    downLinkDataHandle (mcpsIndication);
}

/*!
 * \brief   MLME-Confirm event function
 *
 * \param   [IN] mlmeConfirm - Pointer to the confirm structure,
 *               containing confirm attributes.
 */
static void MlmeConfirm (MlmeConfirm_t *mlmeConfirm)
{
  switch (mlmeConfirm->MlmeRequest)
  {
    case MLME_JOIN:
      {
        if (mlmeConfirm->Status == LORAMAC_EVENT_INFO_STATUS_OK)
        {
          ifDisplayJoined++;
          xprintf ("Joined\n");

          // Status is OK, node has joined the network
          deviceState = DEVICE_STATE_SEND;
        }
        else
        {
          uint32_t rejoin_delay = 30000;
          xprintf ("Join failed, rejoin in %dms\n", rejoin_delay);
          TimerSetValue (&TxNextPacketTimer, rejoin_delay);
          TimerStart (&TxNextPacketTimer);
        }
      }
      break;

    case MLME_LINK_CHECK:
      {
        if (mlmeConfirm->Status == LORAMAC_EVENT_INFO_STATUS_OK)
        {
          // Check DemodMargin
          // Check NbGateways
        }
      }
      break;

    default:
      break;
  }

  NextTx = true;
}

/*!
 * \brief   MLME-Indication event function
 *
 * \param   [IN] mlmeIndication - Pointer to the indication structure.
 */
static void MlmeIndication (MlmeIndication_t *mlmeIndication)
{
  switch (mlmeIndication->MlmeIndication)
  {
    case MLME_SCHEDULE_UPLINK:
      {// The MAC signals that we shall provide an uplink as soon as possible
        OnTxNextPacketTimerEvent ();
        break;
      }
    default:
      break;
  }
}

static void lwan_dev_params_update (void)
{
#ifdef REGION_EU868
  LoRaMacChannelAdd (3, (ChannelParams_t) EU868_LC4);
  LoRaMacChannelAdd (4, (ChannelParams_t) EU868_LC5);
  LoRaMacChannelAdd (5, (ChannelParams_t) EU868_LC6);
  LoRaMacChannelAdd (6, (ChannelParams_t) EU868_LC7);
  LoRaMacChannelAdd (7, (ChannelParams_t) EU868_LC8);
#endif

#ifdef REGION_EU433
  LoRaMacChannelAdd (3, (ChannelParams_t) EU433_LC4);
  LoRaMacChannelAdd (4, (ChannelParams_t) EU433_LC5);
  LoRaMacChannelAdd (5, (ChannelParams_t) EU433_LC6);
  LoRaMacChannelAdd (6, (ChannelParams_t) EU433_LC7);
  LoRaMacChannelAdd (7, (ChannelParams_t) EU433_LC8);
#endif

  MibRequestConfirm_t mibReq;

  mibReq.Type = MIB_CHANNELS_DEFAULT_MASK;
  mibReq.Param.ChannelsMask = userChannelsMask;
  LoRaMacMibSetRequestConfirm (&mibReq);

  mibReq.Type = MIB_CHANNELS_MASK;
  mibReq.Param.ChannelsMask = userChannelsMask;
  LoRaMacMibSetRequestConfirm (&mibReq);
}

LoRaMacPrimitives_t LoRaMacPrimitive;
LoRaMacCallback_t LoRaMacCallback;

void LoRaWanClass::generateDeveuiByChipID ()
{
  int i;
  uint64_t chipid = ESP.getEfuseMac ();//The chip ID is essentially its MAC address (length: 6 bytes).

  for (i = 0; i < 6; i++)
  {
    DevEui [i] = chipid & 0xff;
    chipid = chipid >> 8;
  }

  DevEui [6] = DevEui [1] & DevEui [2];
  DevEui [7] = DevEui [3] & DevEui [4];
}

void LoRaWanClass::init (DeviceClass_t classMode, LoRaMacRegion_t region)
{
  if (classMode == CLASS_B)
  {
    xprintf ("Class B is not supported, switch to Class A\n");
    classMode = CLASS_A;
  }

  MibRequestConfirm_t mibReq;

  LoRaMacPrimitive.MacMcpsConfirm = McpsConfirm;
  LoRaMacPrimitive.MacMcpsIndication = McpsIndication;
  LoRaMacPrimitive.MacMlmeConfirm = MlmeConfirm;
  LoRaMacPrimitive.MacMlmeIndication = MlmeIndication;
  LoRaMacCallback.GetBatteryLevel = BoardGetBatteryLevel;
  LoRaMacCallback.GetTemperatureLevel = NULL;
  LoRaMacInitialization (&LoRaMacPrimitive, &LoRaMacCallback, region);
  TimerStop (&TxNextPacketTimer);
  TimerInit (&TxNextPacketTimer, OnTxNextPacketTimerEvent);

  if (IsLoRaMacNetworkJoined == false)
  {
    char buffer [128];
    size_t l = 0;

    mibReq.Type = MIB_ADR;
    mibReq.Param.AdrEnable = loraWanAdr;
    LoRaMacMibSetRequestConfirm (&mibReq);

    mibReq.Type = MIB_PUBLIC_NETWORK;
    mibReq.Param.EnablePublicNetwork = LORAWAN_PUBLIC_NETWORK;
    LoRaMacMibSetRequestConfirm (&mibReq);

    mibReq.Type = MIB_DEVICE_CLASS;
    mibReq.Param.Class = classMode;
    LoRaMacMibSetRequestConfirm (&mibReq);

    l += snprintf (&buffer [l], sizeof (buffer) - l, "DevEUI=");

    for (int i = 0;i<8;i++)
      l += snprintf (&buffer [l], sizeof (buffer) - l, "%02X", DevEui [i]); 

    xprintf ("%s\n", buffer);

    l = 0;
    l += snprintf (&buffer [l], sizeof (buffer) - l, "LoRaWAN ");

    switch (region)
    {
      case LORAMAC_REGION_AS923:
        l += snprintf (&buffer [l], sizeof (buffer) - l, "AS923");
        break;
      case LORAMAC_REGION_AU915:
        l += snprintf (&buffer [l], sizeof (buffer) - l, "AU915");
        break;
      case LORAMAC_REGION_CN470:
        l += snprintf (&buffer [l], sizeof (buffer) - l, "CN470");
        break;
      case LORAMAC_REGION_CN779:
        l += snprintf (&buffer [l], sizeof (buffer) - l, "CN779");
        break;
      case LORAMAC_REGION_EU433:
        l += snprintf (&buffer [l], sizeof (buffer) - l, "EU433");
        break;
      case LORAMAC_REGION_EU868:
        l += snprintf (&buffer [l], sizeof (buffer) - l, "EU868");
        break;
      case LORAMAC_REGION_KR920:
        l += snprintf (&buffer [l], sizeof (buffer) - l, "KR920");
        break;
      case LORAMAC_REGION_IN865:
        l += snprintf (&buffer [l], sizeof (buffer) - l, "IN876");
        break;
      case LORAMAC_REGION_US915:
        l += snprintf (&buffer [l], sizeof (buffer) - l, "US915");
        break;
      case LORAMAC_REGION_US915_HYBRID:
        l += snprintf (&buffer [l], sizeof (buffer) - l, "US915_HYBRID");
        break;
      case LORAMAC_REGION_LA915:
        l += snprintf (&buffer [l], sizeof (buffer) - l, "LA915");
        break;
    }

    xprintf ("%s, Class %X\n", buffer, loraWanClass + 10);

    lwan_dev_params_update ();
    deviceState = DEVICE_STATE_JOIN;
  }
  else
    deviceState = DEVICE_STATE_SEND;
}

void LoRaWanClass::join ()
{
  if (overTheAirActivation == true)
  {
    xprintf ("Joining...\n");
    MlmeReq_t mlmeReq;

    mlmeReq.Type = MLME_JOIN;

    mlmeReq.Req.Join.DevEui = DevEui;
    mlmeReq.Req.Join.AppEui = AppEui;
    mlmeReq.Req.Join.AppKey = AppKey;
    mlmeReq.Req.Join.NbTrials = 1;

    if (LoRaMacMlmeRequest (&mlmeReq) == LORAMAC_STATUS_OK)
      deviceState = DEVICE_STATE_SLEEP;
    else
      deviceState = DEVICE_STATE_CYCLE;
  }
  else
  {
    MibRequestConfirm_t mibReq;

    mibReq.Type = MIB_NET_ID;
    mibReq.Param.NetID = LORAWAN_NETWORK_ID;
    LoRaMacMibSetRequestConfirm (&mibReq);

    mibReq.Type = MIB_DEV_ADDR;
    mibReq.Param.DevAddr = DevAddr;
    LoRaMacMibSetRequestConfirm (&mibReq);

    mibReq.Type = MIB_NWK_SKEY;
    mibReq.Param.NwkSKey = NwkSKey;
    LoRaMacMibSetRequestConfirm (&mibReq);

    mibReq.Type = MIB_APP_SKEY;
    mibReq.Param.AppSKey = AppSKey;
    LoRaMacMibSetRequestConfirm (&mibReq);

    mibReq.Type = MIB_NETWORK_JOINED;
    mibReq.Param.IsNetworkJoined = true;
    LoRaMacMibSetRequestConfirm (&mibReq);

    deviceState = DEVICE_STATE_SEND;
  }
}

void LoRaWanClass::send (DeviceClass_t classMode)
{
  if (NextTx == true)
    NextTx = SendFrame ();
}

void LoRaWanClass::cycle (uint32_t dutyCycle)
{
  TimerSetValue (&TxNextPacketTimer, dutyCycle);
  TimerStart (&TxNextPacketTimer);
}

void LoRaWanClass::sleep (DeviceClass_t classMode, uint8_t debugLevel)
{
  Radio.IrqProcess ();
  Mcu.sleep (classMode, debugLevel);
}

#if defined (WIFI_LoRa_32) || defined (WIFI_LoRa_32_V2) || defined (Wireless_Stick)

void LoRaWanClass::displayJoining ()
{
  digitalWrite (Vext, LOW);
  delay (20);
  Display.init ();
  delay (20);
  Display.wakeup ();

#ifdef Wireless_Stick
  Display.setFont (ArialMT_Plain_10);
#else
  Display.setFont (ArialMT_Plain_16);
#endif
  Display.setTextAlignment (TEXT_ALIGN_CENTER);
  Display.clear ();
#ifdef Wireless_Stick
  Display.drawString (32, 40, "JOINING...");
#else
  Display.drawString (58, 22, "JOINING...");
#endif
  Display.display ();
}

void LoRaWanClass::displayJoined ()
{
  ifDisplayJoined--;
  digitalWrite (Vext, LOW);
  delay (50);
  Display.wakeup ();
  Display.clear ();

#ifdef Wireless_Stick
  Display.drawString (32, 40, "JOINED");
#else
  Display.drawString (64, 22, "JOINED");
#endif
  Display.display ();
  delay (1000);
  Display.sleep ();
  digitalWrite (Vext, HIGH);
}

void LoRaWanClass::displaySending ()
{
  if (ifDisplayJoined)
    displayJoined ();

  digitalWrite (Vext, LOW);
  delay (20);
  Display.init ();
  Display.wakeup ();

#ifdef Wireless_Stick
  Display.setFont (ArialMT_Plain_10);
#else
  Display.setFont (ArialMT_Plain_16);
#endif
  Display.setTextAlignment (TEXT_ALIGN_CENTER);
  Display.clear ();
#ifdef Wireless_Stick
  Display.drawString (58, 40, "SENDING...");
#else
  Display.drawString (58, 22, "SENDING...");
#endif
  Display.display ();
}

void LoRaWanClass::displayAck ()
{
  if (ifDisplayAck == 0)
    return;

  ifDisplayAck--;

  Display.clear ();
#ifdef Wireless_Stick
  Display.drawString (64, 30, "Got ACK");
#else
  Display.setFont (ArialMT_Plain_10);
  Display.setTextAlignment (TEXT_ALIGN_RIGHT);
  Display.drawString (128, 0, "rssi "+String (ackrssi));
  Display.setFont (ArialMT_Plain_16);
  Display.setTextAlignment (TEXT_ALIGN_CENTER);
  Display.drawString (64, 22, "ACK RECEIVED");
#endif

  if (loraWanClass == CLASS_A)
  {
    Display.setFont (ArialMT_Plain_10);
    Display.setTextAlignment (TEXT_ALIGN_LEFT);
#ifdef Wireless_Stick
    Display.drawString (32, 50, "Sleep in 2S");
#else
    Display.drawString (32, 50, "Deep sleep in 2S");
#endif
  }

  Display.display ();

  if (loraWanClass == CLASS_A)
  {
    delay (2000);
    Display.sleep ();
    digitalWrite (Vext, HIGH);
  }
}

void LoRaWanClass::displayMcuInit ()
{
  Display.wakeup ();
  Display.init ();
  delay (100);

#ifdef Wireless_Stick
  Display.setFont (ArialMT_Plain_10);
  Display.setTextAlignment (TEXT_ALIGN_CENTER);
  Display.clear ();
  Display.drawString (32, 30, "LORAWAN");
  Display.drawString (32, 50, "STARTING");
#else
  Display.setFont (ArialMT_Plain_16);
  Display.setTextAlignment (TEXT_ALIGN_CENTER);
  Display.clear ();
  Display.drawString (64, 11, "LORAWAN");
  Display.drawString (64, 31, "STARTING");
#endif
  Display.display ();
}
#endif

LoRaWanClass LoRaWAN;
