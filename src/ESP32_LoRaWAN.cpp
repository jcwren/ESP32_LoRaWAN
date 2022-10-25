#include <ESP32_LoRaWAN.h>

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
uint8_t appData [LORAWAN_APP_DATA_MAX_SIZE];


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
enum eDeviceState deviceState;
lorawanCallbacks_t lorawanCallbacks;

static void lwan_dev_params_update (void);

/*!
 * \brief   Prepares the payload of the frame
 *
 * \retval  [0: frame could be send, 1: error]
 */
static bool SendFrame (void)
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
      if (lorawanCallbacks.onConfirmedUplinkSending)
        lorawanCallbacks.onConfirmedUplinkSending ();

      mcpsReq.Type = MCPS_CONFIRMED;
      mcpsReq.Req.Confirmed.fPort = appPort;
      mcpsReq.Req.Confirmed.fBuffer = appData;
      mcpsReq.Req.Confirmed.fBufferSize = appDataSize;
      mcpsReq.Req.Confirmed.NbTrials = confirmedNbTrials;
      mcpsReq.Req.Confirmed.Datarate = LORAWAN_DEFAULT_DATARATE;
    }
    else
    {
      if (lorawanCallbacks.onUnconfirmedUplinkSending)
        lorawanCallbacks.onUnconfirmedUplinkSending ();

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
      case MCPS_UNCONFIRMED :
        {
          // Check Datarate
          // Check TxPower
        }
        break;

      case MCPS_CONFIRMED :
        {
          // Check Datarate
          // Check TxPower
          // Check AckReceived
          // Check NbTrials
        }
        break;

      case MCPS_PROPRIETARY :
        break;

      default :
        break;
    }
  }

  NextTx = true;
}

void __attribute__((weak)) downLinkDataHandle (McpsIndication_t *mcpsIndication __attribute__ ((unused)))
{
}

/*!
 * \brief   MCPS-Indication event function
 *
 * \param   [IN] mcpsIndication - Pointer to the indication structure,
 *               containing indication attributes.
 */
static void McpsIndication (McpsIndication_t *mcpsIndication)
{
  if (mcpsIndication->Status != LORAMAC_EVENT_INFO_STATUS_OK)
    return;

  if (lorawanCallbacks.onMcpsIndication)
    lorawanCallbacks.onMcpsIndication ((int) mcpsIndication->Rssi, (int) mcpsIndication->Snr, (int) mcpsIndication->RxDatarate);

    if (lorawanCallbacks.onSysTimeUpdate && (mcpsIndication->DeviceTimeAnsReceived == true))
      lorawanCallbacks.onSysTimeUpdate ();

  delay (10);

  switch (mcpsIndication->McpsIndication)
  {
    case MCPS_UNCONFIRMED :
      break;

    case MCPS_CONFIRMED :
      break;

    case MCPS_PROPRIETARY :
      break;

    case MCPS_MULTICAST :
      break;

    default :
      break;
  }

  //
  // Check Multicast
  // Check Port
  // Check Datarate
  // Check FramePending
  //
  if (mcpsIndication->FramePending == true)
  {
    //
    // The server signals that it has pending data to be sent.
    // We schedule an uplink as soon as possible to flush the server.
    //
    OnTxNextPacketTimerEvent ();
  }

  //
  // Check Buffer
  // Check BufferSize
  // Check Rssi
  // Check Snr
  // Check RxSlot
  //
  if ((mcpsIndication->RxData == true) && lorawanCallbacks.onDataReceived)
    lorawanCallbacks.onDataReceived (mcpsIndication);
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
    case MLME_JOIN :
      {
        if (mlmeConfirm->Status == LORAMAC_EVENT_INFO_STATUS_OK)
        {
          if (lorawanCallbacks.onJoinSuccess)
            lorawanCallbacks.onJoinSuccess ();

          deviceState = DEVICE_STATE_SEND;
        }
        else
        {
          uint32_t rejoin_delay = 30000;

          if (lorawanCallbacks.onJoinFailed)
            rejoin_delay = lorawanCallbacks.onJoinFailed ();

          TimerSetValue (&TxNextPacketTimer, rejoin_delay);
          TimerStart (&TxNextPacketTimer);
        }
      }
      break;

    case MLME_LINK_CHECK :
      {
        if (mlmeConfirm->Status == LORAMAC_EVENT_INFO_STATUS_OK)
        {
          // Check DemodMargin
          // Check NbGateways
        }
      }
      break;

    default :
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
    //
    // The MAC signals that we shall provide an uplink as soon as possible
    //
    case MLME_SCHEDULE_UPLINK :
      OnTxNextPacketTimerEvent ();
        ;
      
    default :
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
  uint64_t chipid = ESP.getEfuseMac (); //The chip ID is essentially its MAC address (length: 6 bytes).

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
    classMode = CLASS_A;

  MibRequestConfirm_t mibReq;

  LoRaMacPrimitive.MacMcpsConfirm = McpsConfirm;
  LoRaMacPrimitive.MacMcpsIndication = McpsIndication;
  LoRaMacPrimitive.MacMlmeConfirm = MlmeConfirm;
  LoRaMacPrimitive.MacMlmeIndication = MlmeIndication;
  LoRaMacCallback.GetBatteryLevel = lorawanCallbacks.onGetBatteryLevel ? lorawanCallbacks.onGetBatteryLevel : BoardGetBatteryLevel;
  LoRaMacCallback.GetTemperatureLevel = lorawanCallbacks.onGetTemperatureLevel;
  LoRaMacInitialization (&LoRaMacPrimitive, &LoRaMacCallback, region);
  TimerStop (&TxNextPacketTimer);
  TimerInit (&TxNextPacketTimer, OnTxNextPacketTimerEvent);

  if (IsLoRaMacNetworkJoined == false)
  {
    mibReq.Type = MIB_ADR;
    mibReq.Param.AdrEnable = loraWanAdr;
    LoRaMacMibSetRequestConfirm (&mibReq);

    mibReq.Type = MIB_PUBLIC_NETWORK;
    mibReq.Param.EnablePublicNetwork = LORAWAN_PUBLIC_NETWORK;
    LoRaMacMibSetRequestConfirm (&mibReq);

    mibReq.Type = MIB_DEVICE_CLASS;
    mibReq.Param.Class = classMode;
    LoRaMacMibSetRequestConfirm (&mibReq);

    if (lorawanCallbacks.onInit)
    {
      const char *regionText;

      switch (region)
      {
        case LORAMAC_REGION_AS923        : regionText = "AS923";        break;
        case LORAMAC_REGION_AU915        : regionText = "AU915";        break;
        case LORAMAC_REGION_CN470        : regionText = "CN470";        break;
        case LORAMAC_REGION_CN779        : regionText = "CN779";        break;
        case LORAMAC_REGION_EU433        : regionText = "EU433";        break;
        case LORAMAC_REGION_EU868        : regionText = "EU868";        break;
        case LORAMAC_REGION_KR920        : regionText = "KR920";        break;
        case LORAMAC_REGION_IN865        : regionText = "IN876";        break;
        case LORAMAC_REGION_US915        : regionText = "US915";        break;
        case LORAMAC_REGION_US915_HYBRID : regionText = "US915_HYBRID"; break;
        case LORAMAC_REGION_LA915        : regionText = "LA915";        break;
        default                          : regionText = "(unknown)";    break;
      }

      lorawanCallbacks.onInit (regionText, loraWanClass);
    }

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

void LoRaWanClass::deviceTimeReq ()
{
  MlmeReq_t mlmeReq;

  mlmeReq.Type = MLME_DEVICE_TIME;

  if (LoRaMacMlmeRequest (&mlmeReq) == LORAMAC_STATUS_OK)
    NextTx = true;
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

LoRaWanClass LoRaWAN;
