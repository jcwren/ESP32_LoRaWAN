#ifndef LORA_H
#define LORA_H

#include <Arduino.h>
#include "SPI.h"
#include "board.h"
#include "Commissioning.h"
#include "Mcu.h"
#include "utilities.h"
#include "board-config.h"
#include "LoRaMac.h"
#include "Commissioning.h"
#include "rtc-board.h"
#include "delay.h"

//
//
//
#define APP_TX_DUTYCYCLE_RND 1000

//
//
//
enum eDeviceState
{
  DEVICE_STATE_INIT,  // 0 -
  DEVICE_STATE_JOIN,  // 1 -
  DEVICE_STATE_SEND,  // 2 -
  DEVICE_STATE_CYCLE, // 3 -
  DEVICE_STATE_SLEEP  // 4 -
};

//
//
//
typedef struct lorawanCallbacks_s
{
  void     (*onInit) (const char *regionText, DeviceClass_t classMode);
  void     (*onJoinSuccess) (void);
  uint32_t (*onJoinFailed) (void);
  void     (*onDataReceived) (McpsIndication_t *mcpsIndication);
  void     (*onConfirmedUplinkSending) (void);
  void     (*onUnconfirmedUplinkSending) (void);
  void     (*onMcpsIndication) (int rssi, int snr, int dataRate);
  void     (*onSysTimeUpdate) (void);
  uint8_t  (*onGetBatteryLevel) (void);
  float    (*onGetTemperatureLevel) (void);
}
lorawanCallbacks_t;

//
//
//
class LoRaWanClass {
public:
  void init (DeviceClass_t classMode, LoRaMacRegion_t region);
  void join ();
  void send (DeviceClass_t classMode);
  void cycle (uint32_t dutyCycle);
  void sleep (DeviceClass_t classMode, uint8_t debugLevel);
  void generateDeveuiByChipID ();
  void deviceTimeReq ();
};

//
//
//
extern lorawanCallbacks_t lorawanCallbacks;
extern enum eDeviceState deviceState;
extern uint8_t appPort;
extern uint32_t txDutyCycleTime;
extern uint8_t appData [LORAWAN_APP_DATA_MAX_SIZE];
extern uint8_t appDataSize;
extern uint32_t txDutyCycleTime;
extern bool overTheAirActivation;
extern LoRaMacRegion_t loraWanRegion;
extern bool loraWanAdr;
extern bool isTxConfirmed;
extern uint32_t appTxDutyCycle;
extern uint8_t confirmedNbTrials;
extern DeviceClass_t loraWanClass;
extern uint8_t DevEui [];
extern uint8_t AppEui [];
extern uint8_t AppKey [];
extern uint8_t NwkSKey [];
extern uint8_t AppSKey [];
extern uint32_t DevAddr;
extern uint16_t userChannelsMask [6];

extern LoRaWanClass LoRaWAN;

//
//
//
#ifdef __cplusplus
extern "C"{
#endif

#ifdef __cplusplus
} // extern "C"
#endif

#endif
