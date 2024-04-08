//+------------------------------------------------------------------+
//|                                                  RSI Signals.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
MqlRates bar[];
double rsiBuffer[]; // Array to store RSI values
input ENUM_APPLIED_PRICE RSIPrice = PRICE_CLOSE;

int OnInit()
  {
//---
   ArraySetAsSeries(bar,true);
   ArraySetAsSeries(rsiBuffer, true); // Set the array as series
   ArrayResize(rsiBuffer, 1000); // Resize the array to hold RSI values
   IndicatorSetInteger(INDICATOR_DIGITS, Digits()); // Set indicator digits to match chart

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   ArrayFree(rsiBuffer);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   CopyRates(_Symbol,PERIOD_CURRENT,0,15,bar);
   double rsi = iRSI(_Symbol,PERIOD_CURRENT,14,RSIPrice);
   // Copy RSI value to buffer
   if (CopyBuffer(rsi, 0, 0, 1000, rsiBuffer) > 0) {
        rsiBuffer[0] = rsi; // Store current RSI value at the beginning of the array
    }
   
 //  if ((bar[1].close > bar[2].close > bar[3].close > bar[4].close) && (rsiBuffer[1]>85)){ 
 //  ObjectCreate(0,"BuyArrow"+TimeToString(bar[1].time),OBJ_ARROW_BUY,0,bar[1].time,bar[1].low) ;
 //  }
   if ((bar[1].close > bar[2].close) && (bar[2].close > bar[3].close) && (bar[3].close > bar[4].close) && (rsiBuffer[1] > 85)) {
        ObjectCreate(0,"BuyArrow"+TimeToString(bar[1].time),OBJ_ARROW_BUY,0,bar[1].time,bar[1].low);
      }
   if ((bar[1].close < bar[2].close) && (bar[2].close < bar[3].close) && (bar[3].close < bar[4].close) && (rsiBuffer[1]<15)){ 
   ObjectCreate(0,"SellArrow"+TimeToString(bar[1].time),OBJ_ARROW_SELL,0,bar[1].time,bar[1].high) ;
   } 
   Comment("RSI[1]:",rsiBuffer[1]);
  }
//+------------------------------------------------------------------+
