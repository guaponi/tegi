//+------------------------------------------------------------------+
//|                                                        Tegi.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Buy me a coffee"
#property link      "https://www.buymeacoffee.com/besibes"
#property version   "1.1"
#property strict
#include <Telegram\Telegram.mqh>
  enum order_type
  {
  ot_instant=0,//Instant
  ot_pending=1//Pending
  };
  enum order_direction
  {
  od_buy=0,//Buy
  od_sell=1//Sell
  };
  enum lot_mode
  {
  lot_mode_static=0,//Static
  lot_mode_risk=1//Risk%
  };
  enum lot_amount
  {
  lot_amount_balance=0,//Balance
  lot_amount_equity=1,//Equity
  lot_amount_free_margin=2//Free Margin
  };
input string notei="<----->";//TELEGRAM SETTINGS :
string TelegramTitle_ExtraField="";//Telegram title (extra field)
int TelegramCheckSeconds=10;//Telegram Stack Check every : (in seconds)
input int TelegramDelaySeconds=300;//Delay For Sending Trade Signal (in seconds) 
input bool TelegramSignals=true;//Send Telegram Signals ? 
input bool TelegramCloseDeleteInform=true;//Inform on Close + Delete ?
input bool TelegramScreenshot=true;//Send Screenshot ? 
input int screenie_x=600;//Screenshot X size (max 2000)
input int screenie_y=600;//Screenshot Y size (max 2000)
input ENUM_ALIGN_MODE screen_align=ALIGN_RIGHT;//image align
string TelegramSignalStart="Signal Service Started";//Test Message when EA starts 
string ChannelStringID="";//Telegram Channel ID 
string InpToken="";//Telegram Token  

input string email="";//Email
input string notez="<----->";//OPEN ON START SETTINGS 
input bool IMMEDIATE=false;//Auto Open, On Start ? 
input bool IMMEDIATE_PENDING_ONLY=false;//Auto Open , Pending Only (OnStart)
input order_direction IMMEDIATE_DIRECTION=od_buy;//Auto Open, Direction : 
input double IMMEDIATE_PENDING=0;//Auto Open, Pending Price : 
input double IMMEDIATE_SLPRICE=0;//Auto Open, SL Price : 
input double IMMEDIATE_TPPRICE=0;//Auto Open, TP Price : 
input bool SATP_SEND_PACKED=false;//Send Same Direction Instant + Pending on BUY/SELL click ?
input bool OrderCompensationLogic=true;//Use Order Compensation Logic for Orders Sent Together ?
input double OrderCompensationLogicPercentage=100;//% for Closure of Limit Order (affects close price)
input int SafeDistanceForBEPApplicationInPoints=10;//Safe Distance for reCalculation of BEPoint  (if price is invalid and needs readjustment)
input lot_mode SATP_LOT_MODE=lot_mode_static;//Lot Mode : 
input lot_amount SATP_LOT_AMOUNT=lot_amount_balance;//Lot Amount : 
input double RiskOrLot=0.1;//Risk Or Lot 
input double InstantLotPercentage=30;//Instant Lot %
input double PendingLotPercentage=70;//Pending Lot %
input bool SATP_BE=true;//BreakEven System :
input double SATP_BE_Trigger_Percentage=20;//% In Profit To Trigger BE
input double SATP_BE_Portion=50;//BreakEven Close % :
input bool SATP_TRAILING=true;//Trailing System : 
input int SATP_TRAILING_DISTANCE=100;//Trailing Distance : 
input bool BrokerECN=false;//Is Broker ECN
input int SATP_SLIPPAGE=100;//Slippage 
input string SatpComment="@axidentaltrader";//Comment 
input int SATP_MAGIC=1231214;//Magic Number
input int SATP_OPEN_ATTEMPTS=1;//Open Attempts 
input uint SATP_OPEN_TIMEOUT=500;//Open Timeout (ms)
input int SATP_CLOSE_ATTEMPTS=1;//Close Attempts
input uint SATP_CLOSE_TIMEOUT=500;//Close Timeout (ms)
input int SATP_MODIFY_ATTEMPTS=1;//Modify Attempts 
input uint SATP_MODIFY_TIMEOUT=400;//Modify Timeout (ms)
input string notea="<->";//DISPLAY SETTINGS 
input int satp_sizex=220;//Size X 
input int satp_row_size=20;//Row Size Y
input string satp_font="Arial";//Font 
input int satp_font_size=10;//Font Size 
input int position_x=10;//position x 
input int position_y=20;//position y
input string satp_title="Satp.Panel";//program title 
input color satp_note_back_color=C'30,30,30';//Label Back Color :
input color satp_note_border_color=C'10,10,10';//Label Border Color : 
input color satp_note_text_color=clrAzure;//Label Text Color :
input color satp_back_color=C'9,9,9';//Back color 
input color satp_back_border_color=C'50,50,50';//Back Border Color
input ENUM_BORDER_TYPE satp_back_border_type=BORDER_RAISED;//back border type
input color satp_title_back_color=clrRoyalBlue;//title back color
input color satp_title_border_color=clrDarkBlue;//title border color
input ENUM_BORDER_TYPE satp_title_border_type=BORDER_RAISED;//title border type 
input color satp_title_text_color=clrOrange;//title text color
input ENUM_BORDER_TYPE satp_buttons_border_type=BORDER_SUNKEN;//buttons border type 
input ENUM_BORDER_TYPE satp_input_border_type=BORDER_RAISED;//inputs border type 
input ENUM_BORDER_TYPE satp_on_border_type=BORDER_RAISED;//"on" state border type
input ENUM_BORDER_TYPE satp_off_border_type=BORDER_FLAT;//"off" state border type 
input color satp_clos_btns_back_color=clrGainsboro;//close buttons back color
input color satp_clos_btns_border_color=clrWheat;//close buttons border color 
input color satp_clos_btns_text_color=clrBlack;//close button text color 
input color satp_edit_back_color=clrBlack;//edit back color
input color satp_edit_border_color=clrGray;//edit border color
input color satp_edit_text_color=clrOrange;//edit text color 
input color satp_on_back_color=clrDarkGoldenrod;//"on" state back color 
input color satp_on_border_color=clrOrange;//"on" state border color
input color satp_on_text_color=clrGold;//"on" state text color 
input color satp_on_buy_back_color=clrMidnightBlue;//"on" buy state back color 
input color satp_on_buy_border_color=clrDodgerBlue;//"on" buy state border color
input color satp_on_buy_text_color=clrGoldenrod;//"on" buy state text color 
input color satp_on_sell_back_color=clrDarkRed;//"on" buy state back color 
input color satp_on_sell_border_color=clrOrangeRed;//"on" buy state border color
input color satp_on_sell_text_color=clrGoldenrod;//"on" buy state text color 
input color satp_off_back_color=clrGray;//"off" state back color 
input color satp_off_border_color=clrBlack;//"off" state border color
input color satp_off_text_color=clrGainsboro;//"off" state text color 
input color satp_profit_back_color=clrDarkGreen;//Profit Back Color 
input color satp_profit_border_color=clrGreen;//Profit Border Color 
input color satp_profit_text_color=clrGoldenrod;//Profit Text Color
input color satp_loss_back_color=clrDarkRed;//Loss Back Color 
input color satp_loss_border_color=clrRed;//Loss Border Color 
input color satp_loss_text_color=clrGoldenrod;//Loss Text Color 
input color satp_command_back_color=clrDarkOrange;//Command Back Color 
input color satp_command_border_color=clrOrange;//Command Border Color 
input color satp_command_text_color=clrBlack;//Command Text Color 
input color lines_op_color=clrWhite;//Lines OpenPrice Color 
input int lines_op_width=1;//Lines OpenPrice Width
input ENUM_LINE_STYLE lines_op_style=STYLE_DASH;//Lines OpenPrice Style  
input color lines_sl_color=clrOrangeRed;//Lines SL Color
input int lines_sl_width=1;//Lines SL Width 
input ENUM_LINE_STYLE lines_sl_style=STYLE_DASH;//Lines SL Style 
input color lines_tp_color=clrDodgerBlue;//Lines TP Color 
input int lines_tp_width=1;//Lines TP Width 
input ENUM_LINE_STYLE lines_tp_style=STYLE_DASH;//Lines TP Style 
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
string SystemTag="SATP_",SystemPanelTag,SystemBuyLinesTag,SystemSellLinesTag;
string SystemFolder="SATP",SystemManualSetupFile="ManualSetup.satp",SystemSymbolLiveTradesFile="",SystemSymbolPendingTradeFile="";
bool SystemReady=false,SystemBusy=false,reason_to_save=false,Minimized=false,ValidAccount=false;
double actual_trail_distance=0,actual_limit=0,compensation_logic_ratio=1,actual_safe_distance=0;

int OnInit()
  {
  //Valid Account Check
  /*
  for the system to perform a check : 
  comment out ValidAccount=true; 
  uncomment if(!CheckEmail()....
  function is CheckEmail() at line #1703
  non web controller limiter at line #1306
  */
  //calcs for compensation logic ratio 
  /*when we close 100% of both limit and market orders then its at the point where 
    loss of market ==(-1)*profit of limit summing to 0
    so ,if we are to close at 50% of the limit order and 100% of the market we must find which point
    covers 100% of the market orders loss ,for the 50% of the limit orders profit to cover the loss
    of the market order it really needs to be 100/50=2 times bigger 
    so to close and enforce compensation : 
    MathAbs(LimitProfit)=(100/HowMuchToCloseOfLimit)*MathAbs(MarketProfit)
    with LimitProfit>0 && MarketProfit<0  
  */
  compensation_logic_ratio=1;
  double comp_calcs=OrderCompensationLogicPercentage;//pass the %
  if(comp_calcs>100) comp_calcs=100;
  if(comp_calcs<0) comp_calcs=1;
  compensation_logic_ratio=100/comp_calcs;
  //calcs for compensation logic ratio ends here 
  ValidAccount=false;
  //if(!CheckEmail()){Alert("Invalid Account.Exiting");ExpertRemove();ValidAccount=false;}
  ValidAccount=true;
  if(ValidAccount)
  {
  REM_Folder=SystemFolder;
  REM_File=Symbol()+"_REM.rem";
  REM.Load(REM_Folder,REM_File);  
  Minimized=false;
  //ArrayFree(TRD);
  ObjectsDeleteAll(0,SystemTag);
  ObjectsDeleteAll(0,"MQLNOTE_");
  //controller 
  ctfxew_controller jc=JCC();
  MASTER_JC_CONTROL=jc.valid;
  MASTER_JC_NOTES=jc.notes;
  MASTER_JC_NEXT_C=jc.next_checktime;
  //control checks
  if(MASTER_JC_CONTROL==false)
    {
    Alert(MASTER_JC_NOTES);
    ExpertRemove();
    }
  if(MASTER_JC_CONTROL==true)
  {
  if(CTFXEW_CONTROL_ACCOUNT||CTFXEW_CONTROL_BROKER||CTFXEW_CONTROL_DATE||CTFXEW_CONTROL_USER) CreateDemoNote();    
 
  actual_safe_distance=((double)SafeDistanceForBEPApplicationInPoints)*Point();
  TRD_SIZE=0;
  TRD_TOTAL=0;
  SystemBusy=true;
  SystemReady=false;
  reason_to_save=false;
  actual_trail_distance=((double)SATP_TRAILING_DISTANCE)*Point();
  actual_limit=((double)MarketInfo(Symbol(),MODE_STOPLEVEL))*Point();
  SystemPanelTag=SystemTag+"PANEL_";
  SystemBuyLinesTag=SystemTag+"BUY_PENDING_";
  SystemSellLinesTag=SystemTag+"SELL_PENDING_";
  SystemSymbolLiveTradesFile=Symbol()+"_LiveTrades.satp";
  SystemSymbolPendingTradeFile=Symbol()+"_Pending.satp";
  LOAD();
  BuildDeck(false,position_x,position_y);
  SATP.ReCalc();
  ArrayFree(TeleStack);
  TeleStackTotal=0;TeleStackSize=0;
  //Prepare Telegram if on
    if(TelegramSignals)
    {
    if(MQLInfoInteger(MQL_TESTER)==0) StartTelegramService();
    if(telegram_running) EventSetTimer(TelegramCheckSeconds);
    }
  //Prepare Telegram if on 
  //if auto execute 
  if(IMMEDIATE)
  {
  bool proceed=true;
  //check one , did it load from terminal reopen , reconnection ,recompile ,tf change ,inputs change 
  if(REM.RemovalReason==REM_ACCOUNT_CHANGE_RECONNECTION||REM.RemovalReason==REM_RECOMPILED||REM.RemovalReason==REM_SYMBOL_OR_TF_CHANGE||REM.RemovalReason==REM_TERMINAL_CLOSED||REM.RemovalReason==REM_USER_CHANGED_INPUTS) proceed=false;
  if(proceed)
    {
    if(IMMEDIATE_DIRECTION==od_buy) SATP.BuyPendingInput=IMMEDIATE_PENDING;
    if(IMMEDIATE_DIRECTION==od_sell) SATP.SellPendingInput=IMMEDIATE_PENDING;
    SATP.SLInputPrice=IMMEDIATE_SLPRICE;
    SATP.TPInputPrice=IMMEDIATE_TPPRICE;
    SATP.LotSizeInput=RiskOrLot;
    SATP.LotRiskInput=RiskOrLot;
    SATP.ACTUAL_SATP_LOT_MODE=SATP_LOT_MODE;
    SATP.ReCalc();
    order_type immediate_type=ot_instant;
    if(IMMEDIATE_PENDING_ONLY) immediate_type=ot_pending;
    SATP.Execute(IMMEDIATE_DIRECTION,immediate_type,SATP_SEND_PACKED);
    }
  //proceed ends here 
  }
  //if auto execute on open 
 
  SystemReady=true;
  SystemBusy=false;
  }
  //controller ends here      
  }
  //Valid Account Check Ends Here 
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  ObjectsDeleteAll(0,SystemTag); 
  ObjectsDeleteAll(0,"MQLNOTE_");
  ArrayFree(TRD);
  TRD_SIZE=0;
  TRD_TOTAL=0;  
  REM.Set(reason,TimeLocal());
  REM.Save(REM_Folder,REM_File);  
  if(telegram_running) EventKillTimer();
  ArrayFree(TeleStack);
  TeleStackTotal=0;
  TeleStackSize=0;
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
  //controller 
  ctfxew_controller jc=JCC();
  MASTER_JC_CONTROL=jc.valid;
  MASTER_JC_NOTES=jc.notes;
  MASTER_JC_NEXT_C=jc.next_checktime;
  //control checks
  if(MASTER_JC_CONTROL==false)
    {
    Alert(MASTER_JC_NOTES);
    ExpertRemove();
    }
  if(MASTER_JC_CONTROL==true)
  { 
  if(SystemBusy==false&&SystemReady==true)
    {
    SystemBusy=true;
    for(int t=0;t<TRD_TOTAL;t++) TRD[t].MonitorIt();
    if(PENDING.Set) PENDING.SelfCheck();
    //if compensation logic
      if(OrderCompensationLogic&&SATP_SEND_PACKED&&SATP.OrderCompensationLogicTrigger_PendingTurned&&SATP.OrderCompensationLogicTrigger_LimitOrder)
      {
      //and we have 2 orders in the system - and we close 100% of the limit order - so both 
        if(TRD_TOTAL==2&&OrderCompensationLogicPercentage>=100)
        {
        double sum=0;
        int calced=0;
        for(int s=0;s<TRD_TOTAL;s++)
          {
          bool selec=OrderSelect(TRD[s].Ticket,SELECT_BY_TICKET);
           if(selec)
           {
           calced++;
           sum+=OrderProfit();
           }
          }
        if(calced==2&&sum>=0){CloseAllLiveTrades();Alert("Order Compensation Logic Activated!");}
        }
      //and we have 2 orders in the system - and we close 100% of the limit order -so both ends here 
      //and we have 2 orders in the system - and we close <100% of the limit order - so one
        if(TRD_TOTAL==2&&OrderCompensationLogicPercentage<100)
        {
        int pTicket=-1,mTicket=-1,calced=0;
        double pProfit=0,mProfit=0;
        for(int t=0;t<TRD_TOTAL;t++)
          {
          bool selec=OrderSelect(TRD[t].Ticket,SELECT_BY_TICKET);
          if(selec)
          {
          calced++;
          if(TRD[t].IsFromLimitOrder){pTicket=TRD[t].Ticket;pProfit=OrderProfit();}
          if(!TRD[t].IsFromLimitOrder){mTicket=TRD[t].Ticket;mProfit=OrderProfit();}
          }
          }
        //if valid captures
          if(calced==2&&pTicket>-1&&mTicket>-1)
          {
          double atleast=compensation_logic_ratio*MathAbs(mProfit);
          //if pending profit is positive 
            if(pProfit>0&&mProfit<=0&&pProfit>=atleast)
            {
            //cancel compensation trigger
              SATP.OrderCompensationLogicTrigger_PendingTurned=false;            
            //close market order
              for(int t=0;t<TRD_TOTAL;t++)
              {
              if(TRD[t].Ticket==mTicket){int ct=TRD[t].CloseTrade(100,TRD[t].Lot);TRD[t].ToBeRemoved=true;break;}
              } 
            //close partial previous pending 
              for(int t=0;t<TRD_TOTAL;t++)
              {
              if(TRD[t].Ticket==pTicket)
                {
                int ct=TRD[t].CloseTrade(OrderCompensationLogicPercentage,TRD[t].Lot);
                if(ct!=-1)
                  {
                  TRD[t].Ticket=ct;
                  //assign new full lots
                  bool sel=OrderSelect(TRD[t].Ticket,SELECT_BY_TICKET);
                  if(sel)
                  {
                  TRD[t].Lot=OrderLots();
                  //enable trail and be applied and apply it
                      double originaltp=OrderTakeProfit();
                      TRD[t].Modify(TRD[t].OpenPrice,originaltp);
                      if(SATP_TRAILING) TRD[t].Trailing=true;
                      TRD[t].BEApplied=true;                          
                    SAVE();                    
                  }
                  //if selected ends here
                  }
                break;
                }
              }
            int ts=TRD_TOTAL-1;
            for(int t=ts;t>=0;t--)
            {
            if(TRD[t].ToBeRemoved)
              {
              TRD[t]=TRD[TRD_TOTAL-1];
              TRD_TOTAL--;
              }
            }               
            }
          //if pending profit is positive ends her e
          }
        //if valid captures 
        }
      //and we have 2 orders in the system - and we close <100% of the limit order - so one ends here 
      }
    //if compensation logic is on
    SystemBusy=false;
    }   
  }
  //controller ends here    
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
  if(telegram_running&&TelegramSignals&&TeleStackTotal>0){TeleStackMonitor(TimeLocal());}
  }
  
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
    if(!SystemBusy&&SystemReady)
    {
      //click
      if(id==CHARTEVENT_OBJECT_CLICK)
      {
        if(sparam==SystemPanelTag+"TITLE")
        {
        SystemBusy=true;
        Minimized=!Minimized;
        BuildDeck(Minimized,position_x,position_y);
        if(!Minimized) SATP.ReCalc();
        SystemBusy=false;
        }
      //close live
        if(sparam==SystemPanelTag+"_CLOSE_LIVE")
        {
        CloseAllLiveTrades();
        SATP.ReCalc();
        reason_to_save=true;
        }
      //close pending 
        if(sparam==SystemPanelTag+"_CLOSE_PENDING")
        {
        PENDING.Delete();
        SATP.ReCalc();
        reason_to_save=true;
        }
      //close all 
        if(sparam==SystemPanelTag+"_KILL_ALL")
        {
        CloseAllLiveTrades();
        PENDING.Delete();
        SATP.ReCalc();
        reason_to_save=true;
        }
      }
      //click
    //settings part ends her e
    //click 
    if(id==CHARTEVENT_OBJECT_CLICK)
    {
    //buy
      if(sparam==SystemPanelTag+"MANUAL_TYPE_BUY")
      {
      SATP.Execute(od_buy,ot_instant,SATP_SEND_PACKED);
      reason_to_save=true;
      }
    //sell
      if(sparam==SystemPanelTag+"MANUAL_TYPE_SELL")
      {
      SATP.Execute(od_sell,ot_instant,SATP_SEND_PACKED);
      reason_to_save=true;
      }
    //buy limit
      if(sparam==SystemPanelTag+"MANUAL_TYPE_BUY_LIMIT")
      {
      SATP.Execute(od_buy,ot_pending,SATP_SEND_PACKED);
      reason_to_save=true;
      }
    //sell limit
      if(sparam==SystemPanelTag+"MANUAL_TYPE_SELL_LIMIT")
      {
      SATP.Execute(od_sell,ot_pending,SATP_SEND_PACKED);
      reason_to_save=true;
      }      
    }
    //click 
    //drag
    if(id==CHARTEVENT_OBJECT_DRAG)
    {
    //buy pending op
      if(sparam==SystemBuyLinesTag+"_OP")
        {
        double new_price=ObjectGetDouble(0,sparam,OBJPROP_PRICE);
        SATP.BuyPendingInput=NormalizeDouble(new_price,Digits());
        SATP.ReCalc();
        reason_to_save=true;
        }
    //sell pending op
      if(sparam==SystemSellLinesTag+"_OP")
        {
        double new_price=ObjectGetDouble(0,sparam,OBJPROP_PRICE);
        SATP.SellPendingInput=NormalizeDouble(new_price,Digits());
        SATP.ReCalc();
        reason_to_save=true;
        }        
    }
    //drag ends here 
    //endedit
    if(id==CHARTEVENT_OBJECT_ENDEDIT)
    {
    //stop loss
      if(sparam==SystemPanelTag+"MANUAL_SL_PRICE")
      {
      string ovi=ObjectGetString(0,sparam,OBJPROP_TEXT);
      int rep=StringReplace(ovi,"SL@","");
          rep=StringReplace(ovi,"SL","");
          rep=StringReplace(ovi,"@","");
          rep=StringReplace(ovi,":","");
          rep=StringReplace(ovi," ","");
      SATP.SLInputPrice=NormalizeDouble(StringToDouble(ovi),Digits());
      SATP.ReCalc();      
      reason_to_save=true;
      }
    //take profit
      if(sparam==SystemPanelTag+"MANUAL_TP_PRICE")
      {
      string ovi=ObjectGetString(0,sparam,OBJPROP_TEXT);
      int rep=StringReplace(ovi,"TP@","");
          rep=StringReplace(ovi,"TP","");
          rep=StringReplace(ovi,"@","");
          rep=StringReplace(ovi,":","");
          rep=StringReplace(ovi," ","");
      SATP.TPInputPrice=NormalizeDouble(StringToDouble(ovi),Digits());
      SATP.ReCalc();
      reason_to_save=true;
      }   
    //Lot Size 
      if(sparam==SystemPanelTag+"MANUAL_LOT_SIZE")
      {
      string ovi=ObjectGetString(0,sparam,OBJPROP_TEXT);
      int rep=StringReplace(ovi,"LotSize : ","");
          rep=StringReplace(ovi,"LotSize","");
          rep=StringReplace(ovi," : ","");
          rep=StringReplace(ovi,":","");
          rep=StringReplace(ovi," ","");
      SATP.ACTUAL_SATP_LOT_MODE=lot_mode_static;
      SATP.LotSizeInput=CheckLot(Symbol(),StringToDouble(ovi));
      SATP.ReCalc();
      reason_to_save=true;      
      }  
    //Lot Risk
      if(sparam==SystemPanelTag+"MANUAL_LOT_SIZE_PERCENTAGE")
      {
      string ovi=ObjectGetString(0,sparam,OBJPROP_TEXT);
      int rep=StringReplace(ovi,"Risk% : ","");
          rep=StringReplace(ovi,"Risk%","");
          rep=StringReplace(ovi,"Gain% : ","");
          rep=StringReplace(ovi,"Gain%","");
          rep=StringReplace(ovi," : ","");
          rep=StringReplace(ovi,":","");
          rep=StringReplace(ovi," ","");
      SATP.ACTUAL_SATP_LOT_MODE=lot_mode_risk;
      SATP.LotRiskInput=StringToDouble(ovi);
      SATP.ReCalc();
      reason_to_save=true;    
      }
    //buy limit price 
      if(sparam==SystemPanelTag+"MANUAL_TYPE_BUY_LIMIT_PRICE")
      {
      string ovi=ObjectGetString(0,sparam,OBJPROP_TEXT);
      int rep=StringReplace(ovi,"@","");
      SATP.BuyPendingInput=NormalizeDouble(StringToDouble(ovi),Digits());
      SATP.ReCalc();
      reason_to_save=true;
      }
    //sell limit price 
      if(sparam==SystemPanelTag+"MANUAL_TYPE_SELL_LIMIT_PRICE")
      {
      string ovi=ObjectGetString(0,sparam,OBJPROP_TEXT);
      int rep=StringReplace(ovi,"@","");
      SATP.SellPendingInput=NormalizeDouble(StringToDouble(ovi),Digits());
      SATP.ReCalc();
      reason_to_save=true;
      }      
    }
    //endedit
    //manual part ends here 
  }
  //if ready and not busy ends here  
  if(reason_to_save) SAVE();
  }
//+------------------------------------------------------------------+

//build deck 
void BuildDeck(bool minimized,int px,int py)
{
int full_btn_size=satp_sizex;
int half_btn_size=satp_sizex/2;
int third_btn_size=satp_sizex/3;
int quarter_btn_size=satp_sizex/4;
int third_half=third_btn_size/2;
int quarter_half=quarter_btn_size/2;
int normal_gap=satp_row_size/4;
ObjectsDeleteAll(0,SystemPanelTag);
string objna="";
int penx=px;
int peny=py;
//background 
objna=SystemPanelTag+"BACK";
if(!minimized) HS_Create_Btn(ChartID(),0,objna,satp_sizex,satp_row_size*13,penx,peny,satp_font,satp_font_size,satp_back_color,satp_back_border_color,satp_back_border_type,clrNONE,ALIGN_CENTER,"",false,false);
if(minimized) HS_Create_Btn(ChartID(),0,objna,satp_sizex,(int)(satp_row_size*1.5),penx,peny,satp_font,satp_font_size,satp_back_color,satp_back_border_color,satp_back_border_type,clrNONE,ALIGN_CENTER,"",false,false); 
//title 
objna=SystemPanelTag+"TITLE";
HS_Create_Btn(ChartID(),0,objna,satp_sizex+6,satp_row_size,penx-3,peny+2,satp_font,satp_font_size,satp_title_back_color,satp_title_border_color,satp_title_border_type,satp_title_text_color,ALIGN_CENTER,satp_title,false,false);
peny=peny+2+satp_row_size+normal_gap;
//if not minimized 
if(!minimized)
{
  //buy btn
    penx=px;
    objna=SystemPanelTag+"MANUAL_TYPE_BUY";
    HS_Create_Btn(ChartID(),0,objna,half_btn_size-10,satp_row_size*2,penx+10,peny,satp_font,satp_font_size,satp_on_buy_back_color,satp_on_buy_border_color,satp_on_border_type,satp_on_buy_text_color,ALIGN_CENTER,"BUY",false,false);
    penx+=half_btn_size;
    objna=SystemPanelTag+"MANUAL_TYPE_SELL";
    HS_Create_Btn(ChartID(),0,objna,half_btn_size-10,satp_row_size*2,penx,peny,satp_font,satp_font_size,satp_on_sell_back_color,satp_on_sell_border_color,satp_on_border_type,satp_on_sell_text_color,ALIGN_CENTER,"SELL",false,false);
    peny+=normal_gap*2+satp_row_size*2;
    //limit buy 
    penx=px;
    objna=SystemPanelTag+"MANUAL_TYPE_BUY_LIMIT";
    HS_Create_Btn(ChartID(),0,objna,half_btn_size-10,satp_row_size,penx+10,peny,satp_font,satp_font_size,satp_on_buy_back_color,satp_on_buy_border_color,satp_on_border_type,satp_on_buy_text_color,ALIGN_CENTER,"BUY LIMIT",false,false);
    //limit buy price 
    penx+=half_btn_size;
    objna=SystemPanelTag+"MANUAL_TYPE_BUY_LIMIT_PRICE";
    HS_Create_Edit(ChartID(),0,objna,half_btn_size-10,satp_row_size,penx,peny,satp_font,satp_font_size,satp_edit_back_color,satp_edit_border_color,satp_input_border_type,satp_edit_text_color,ALIGN_CENTER,"@",false,false,false);
    peny+=satp_row_size+normal_gap;
    //limit sell
    penx=px;
    objna=SystemPanelTag+"MANUAL_TYPE_SELL_LIMIT";
    HS_Create_Btn(ChartID(),0,objna,half_btn_size-10,satp_row_size,penx+10,peny,satp_font,satp_font_size,satp_on_sell_back_color,satp_on_sell_border_color,satp_on_border_type,satp_on_sell_text_color,ALIGN_CENTER,"SELL LIMIT",false,false);
    penx+=half_btn_size;
    objna=SystemPanelTag+"MANUAL_TYPE_SELL_LIMIT_PRICE";
    HS_Create_Edit(ChartID(),0,objna,half_btn_size-10,satp_row_size,penx,peny,satp_font,satp_font_size,satp_edit_back_color,satp_edit_border_color,satp_input_border_type,satp_edit_text_color,ALIGN_CENTER,"@",false,false,false);  
  //Stop Loss Price + TP price 
    penx=px;
    peny+=normal_gap+satp_row_size;
    objna=SystemPanelTag+"MANUAL_SL_PRICE";
    HS_Create_Edit(ChartID(),0,objna,half_btn_size-10,satp_row_size,penx+10,peny,satp_font,satp_font_size,satp_loss_back_color,satp_loss_border_color,satp_input_border_type,satp_loss_text_color,ALIGN_CENTER,"SL@",false,false,false);
    penx+=half_btn_size;
    objna=SystemPanelTag+"MANUAL_TP_PRICE";
    HS_Create_Edit(ChartID(),0,objna,half_btn_size-10,satp_row_size,penx,peny,satp_font,satp_font_size,satp_profit_back_color,satp_profit_border_color,satp_input_border_type,satp_profit_text_color,ALIGN_CENTER,"TP@",false,false,false);
  //label for lot settuings 
    penx=px;
    peny+=normal_gap+satp_row_size;
    objna=SystemPanelTag+"_LOT_LABEL";
    HS_Create_Btn(ChartID(),0,objna,full_btn_size+6,satp_row_size,penx-3,peny,satp_font,satp_font_size,satp_note_back_color,satp_note_border_color,BORDER_RAISED,satp_note_text_color,ALIGN_CENTER,"Lot Settings : ",false,false); 
  //inputs + displays 
    penx=px;
    peny+=normal_gap+satp_row_size;
    objna=SystemPanelTag+"MANUAL_LOT_SIZE";
    HS_Create_Edit(ChartID(),0,objna,half_btn_size-10,satp_row_size,penx+10,peny,satp_font,satp_font_size,satp_edit_back_color,satp_edit_border_color,satp_input_border_type,satp_edit_text_color,ALIGN_CENTER,"Lot Size : ",false,false,false);
    penx+=half_btn_size;
    objna=SystemPanelTag+"MANUAL_LOT_SIZE_PERCENTAGE";
    HS_Create_Edit(ChartID(),0,objna,half_btn_size-10,satp_row_size,penx,peny,satp_font,satp_font_size,satp_edit_back_color,satp_edit_border_color,satp_input_border_type,satp_edit_text_color,ALIGN_CENTER,"Risk % : ",false,false,false);
    penx=px;
    peny+=normal_gap+satp_row_size;
    objna=SystemPanelTag+"_CLOSE_PENDING";
    HS_Create_Btn(ChartID(),0,objna,half_btn_size-10,satp_row_size,penx+10,peny,satp_font,satp_font_size,satp_command_back_color,satp_command_border_color,BORDER_FLAT,satp_command_text_color,ALIGN_CENTER,"ClosePending",false,false);
    penx+=half_btn_size;
    objna=SystemPanelTag+"_CLOSE_LIVE";
    HS_Create_Btn(ChartID(),0,objna,half_btn_size-10,satp_row_size,penx,peny,satp_font,satp_font_size,satp_command_back_color,satp_command_border_color,BORDER_FLAT,satp_command_text_color,ALIGN_CENTER,"CloseLive",false,false);
  //close everything 
    penx=px;
    peny+=normal_gap+satp_row_size;
    objna=SystemPanelTag+"_KILL_ALL";
    HS_Create_Btn(ChartID(),0,objna,full_btn_size-20,satp_row_size,penx+10,peny,satp_font,satp_font_size,satp_command_back_color,satp_command_border_color,BORDER_FLAT,satp_command_text_color,ALIGN_CENTER,"CloseEverything",false,false);
        
}
//if not minimized ends here 
}
//build deck ends here 

//system
struct satp
{
bool OrderCompensationLogicTrigger_PendingTurned,OrderCompensationLogicTrigger_LimitOrder;
lot_mode ACTUAL_SATP_LOT_MODE;
double TVOL;//tick value for one lot -in case it cant load 
double MARI;//margin initial for one lot in case it cant load 
bool BuyPendingLines,SellPendingLines;
double BuyPendingInput,SellPendingInput,SLInputPrice,TPInputPrice,LotRiskInput,LotSizeInput;
double BuyPendingSL,BuyPendingTP,SellPendingSL,SellPendingTP,LotInstant,LotPending;
satp(void){OrderCompensationLogicTrigger_PendingTurned=false;OrderCompensationLogicTrigger_LimitOrder=false;ACTUAL_SATP_LOT_MODE=SATP_LOT_MODE;TVOL=0;MARI=0;BuyPendingLines=false;SellPendingLines=false;BuyPendingInput=0;SellPendingInput=0;SLInputPrice=0;TPInputPrice=0;LotRiskInput=0;LotSizeInput=0;BuyPendingSL=0;BuyPendingTP=0;SellPendingSL=0;SellPendingTP=0;LotInstant=0;LotPending=0;}
void ReCalc()
     {
     //if buy pending price is set 
       if(BuyPendingInput!=0)
       {
       BuyPendingSL=MathMin(SLInputPrice,TPInputPrice);
       BuyPendingTP=MathMax(TPInputPrice,SLInputPrice);
       if(BuyPendingTP<=BuyPendingInput) BuyPendingTP=0;
       if(BuyPendingSL>=BuyPendingInput) BuyPendingSL=0;
       UpdateBuyPendingLines();
       }
     //if sell pending price is set 
       if(SellPendingInput!=0)
       {
       SellPendingSL=MathMax(SLInputPrice,TPInputPrice);
       SellPendingTP=MathMin(SLInputPrice,TPInputPrice);
       if(SellPendingSL<=SellPendingInput) SellPendingSL=0;
       if(SellPendingTP>=SellPendingInput) SellPendingTP=0;
       UpdateSellPendingLines();
       }
     CalculateLots();
     UpdatePanel();
     }
  //execute 
  void Execute(order_direction direction,order_type type,bool auto)
  {
  SystemBusy=true;
  //instant 
    if(type==ot_instant)
    {
    string order_direction_text="";
    //if viable 
      bool viable=true;
      double newmargin=0;
      if(direction==od_buy) newmargin=AccountFreeMarginCheck(Symbol(),OP_BUY,LotInstant);
      if(direction==od_sell) newmargin=AccountFreeMarginCheck(Symbol(),OP_SELL,LotInstant);
      if(newmargin<=0||GetLastError()==134) viable=false;
      if(!viable) Alert("Not enough margin for new order on "+Symbol());
      if(viable)
      {
      color clr=clrBlue;
      if(direction==od_sell) clr=clrRed;
      int atts=0;
      int tick=-1;//ticket 
      double op=0,sl=0,tp=0,usedtp=0,usedsl=0;
      //attempts to open 
      while(atts<SATP_OPEN_ATTEMPTS&&tick==-1)
           {
           ENUM_ORDER_TYPE OP=0;
           atts++;
           if(direction==od_buy)
             {
             order_direction_text="Buy";
             op=Ask;
             OP=OP_BUY;
             tp=MathMax(TPInputPrice,SLInputPrice);
             sl=MathMin(TPInputPrice,SLInputPrice);
             if(tp<=Ask) tp=0;
             if(sl>=Bid) sl=0;
             usedtp=tp;usedsl=sl;
             }
           if(direction==od_sell)
             {
             order_direction_text="Sell";
             op=Bid;
             OP=OP_SELL;
             tp=MathMin(TPInputPrice,SLInputPrice);
             sl=MathMax(TPInputPrice,SLInputPrice);
             if(tp>=Bid) tp=0;
             if(sl<=Ask) sl=0;
             usedtp=tp;usedsl=sl;
             }
           if(BrokerECN){usedtp=0;usedsl=0;}
           tick=OrderSend(Symbol(),OP,LotInstant,op,SATP_SLIPPAGE,usedsl,usedtp,SatpComment,SATP_MAGIC,0,clr);
           if(tick==-1&&atts<=SATP_OPEN_ATTEMPTS) Sleep(SATP_OPEN_TIMEOUT);
           }
           //if no success alert user 
           if(tick==-1) Alert("Could Not Place Trade ,Try Again! Error["+IntegerToString(GetLastError())+"]");
           //if success 
           if(tick!=-1)
           {     
           TRD_TOTAL++;
           if(TRD_TOTAL>TRD_SIZE)
           {
           TRD_SIZE+=TRD_STEP;
           ArrayResize(TRD,TRD_SIZE,0);
           }
           TRD[TRD_TOTAL-1].Add(tick,false);
           //if broker is ecn we need to place systemic stops 
             if(BrokerECN)
               {
               Sleep(SATP_OPEN_TIMEOUT);
               TRD[TRD_TOTAL-1].Modify(sl,tp);
               }
           SAVE();
           //if telegram is on
             if(telegram_running&&TelegramSignals)
             {
             string text=Symbol()+"["+telegram_tf_for_images+"] New "+order_direction_text+" opened\nPrice : "+DoubleToString(op,Digits())+"\nStopLoss : "+DoubleToString(sl,Digits())+"\nTakeProfit : "+DoubleToString(tp,Digits());
             if(TelegramTitle_ExtraField!="") text=TelegramTitle_ExtraField+"\n"+text;
             TeleStackAdd(TimeLocal(),TelegramScreenshot,text,TelegramDelaySeconds);
             }
           //if telegram is on ends here 
           ObjectsDeleteAll(0,SystemBuyLinesTag);
           ObjectsDeleteAll(0,SystemSellLinesTag);
           BuyPendingLines=false;
           SellPendingLines=false;    
           }
           //if success ends here 
           //attempts to open ends here 
      }
    //if viable ends here 
    }
  //instant 
  //pending 
    if((type==ot_pending||auto)&&((direction==od_buy&&BuyPendingInput>0)||(direction==od_sell&&SellPendingInput>0)))
    {
    string order_direction_text="";
    if(type!=ot_pending&&auto) Sleep(SATP_OPEN_TIMEOUT);
    if(PENDING.Set&&PENDING.Ticket!=-1) PENDING.Delete();
    ENUM_ORDER_TYPE OP=NULL;
    double opp=0;
    //buy above current price 
      if(direction==od_buy&&BuyPendingInput>Ask){OP=OP_BUYSTOP;opp=BuyPendingInput;order_direction_text="BuyStop";}
    //buy below current price 
      if(direction==od_buy&&BuyPendingInput<Bid){OP=OP_BUYLIMIT;opp=BuyPendingInput;order_direction_text="BuyLimit";}
    //sell above current price
      if(direction==od_sell&&SellPendingInput>Ask){OP=OP_SELLLIMIT;opp=SellPendingInput;order_direction_text="SellLimit";}
    //sell below current price 
      if(direction==od_sell&&SellPendingInput<Bid){OP=OP_SELLSTOP;opp=SellPendingInput;order_direction_text="SellStop";}
    //attempts   
      int tick=-1;
      int atts=0;
      color clr=clrBlue;
      if(direction==od_sell) clr=clrRed;
      double sl=0,tp=0;
           if(direction==od_buy)
             {
             tp=MathMax(TPInputPrice,SLInputPrice);
             sl=MathMin(TPInputPrice,SLInputPrice);
             if(tp<=opp) tp=0;
             if(sl>=opp) sl=0;
             }
           if(direction==od_sell)
             {
             tp=MathMin(TPInputPrice,SLInputPrice);
             sl=MathMax(TPInputPrice,SLInputPrice);
             if(tp>=opp) tp=0;
             if(sl<=opp) sl=0;
             }      
      while(tick==-1&&atts<SATP_OPEN_ATTEMPTS)
      {
      atts++;
      tick=OrderSend(Symbol(),OP,LotPending,opp,SATP_SLIPPAGE,sl,tp,SatpComment,SATP_MAGIC,0,clr);
      if(tick==-1&&atts<=SATP_OPEN_ATTEMPTS) Sleep(SATP_OPEN_TIMEOUT);
      }
    //attempts ends here 
    //if it succeeds 
      if(tick==-1) Alert("Could Not Place Pending Order  Error["+IntegerToString(GetLastError())+"]");
      if(tick!=-1)
      {
      PENDING.WasLimitOrder=false;
      PENDING.Set=true;
      PENDING.Ticket=tick;
      SATP.OrderCompensationLogicTrigger_LimitOrder=false;
      if(OP==OP_BUYLIMIT||OP==OP_SELLLIMIT){PENDING.WasLimitOrder=true;SATP.OrderCompensationLogicTrigger_LimitOrder=true;}     
           SAVE();
           //if telegram is on
             if(telegram_running&&TelegramSignals)
             {
             string text=Symbol()+"["+telegram_tf_for_images+"] New "+order_direction_text+" placed\nPrice : "+DoubleToString(opp,Digits())+"\nStopLoss : "+DoubleToString(sl,Digits())+"\nTakeProfit : "+DoubleToString(tp,Digits());
             if(TelegramTitle_ExtraField!="") text=TelegramTitle_ExtraField+"\n"+text;
             TeleStackAdd(TimeLocal(),TelegramScreenshot,text,TelegramDelaySeconds);
             }
           //if telegram is on ends here 
           ObjectsDeleteAll(0,SystemBuyLinesTag);
           ObjectsDeleteAll(0,SystemSellLinesTag);
           BuyPendingLines=false;
           SellPendingLines=false;    
      }
    //if it succeeds ends here 
    }
  //pending 
  SystemBusy=false;
  }
  //execute ends here     
void UpdateBuyPendingLines()
     {
     if(BuyPendingLines==true)
       {
       //open
       UpdateHline(0,SystemBuyLinesTag+"_OP",BuyPendingInput);
       UpdateHline(0,SystemBuyLinesTag+"_SL",BuyPendingSL);
       UpdateHline(0,SystemBuyLinesTag+"_TP",BuyPendingTP);
       }
     if(BuyPendingLines==false)
       {
       BuyPendingLines=true;
       CreateHLine(0,0,SystemBuyLinesTag+"_OP",BuyPendingInput,lines_op_color,lines_op_width,lines_op_style,true);
       CreateHLine(0,0,SystemBuyLinesTag+"_SL",BuyPendingSL,lines_sl_color,lines_sl_width,lines_sl_style,false);
       CreateHLine(0,0,SystemBuyLinesTag+"_TP",BuyPendingTP,lines_tp_color,lines_tp_width,lines_tp_style,false);
       }
     }
void UpdateSellPendingLines()
     {
     if(SellPendingLines==true)
       {
       //open
       UpdateHline(0,SystemSellLinesTag+"_OP",SellPendingInput);
       UpdateHline(0,SystemSellLinesTag+"_SL",SellPendingSL);
       UpdateHline(0,SystemSellLinesTag+"_TP",SellPendingTP);
       }
     if(SellPendingLines==false)
       {
       SellPendingLines=true;
       CreateHLine(0,0,SystemSellLinesTag+"_OP",SellPendingInput,lines_op_color,lines_op_width,lines_op_style,true);
       CreateHLine(0,0,SystemSellLinesTag+"_SL",SellPendingSL,lines_sl_color,lines_sl_width,lines_sl_style,false);
       CreateHLine(0,0,SystemSellLinesTag+"_TP",SellPendingTP,lines_tp_color,lines_tp_width,lines_tp_style,false);
       }
     }     
void UpdatePanel()
     {
     ObjectSetString(0,SystemPanelTag+"MANUAL_LOT_SIZE",OBJPROP_TEXT,"Lot Size : "+DoubleToString(LotSizeInput,2));
     ObjectSetString(0,SystemPanelTag+"MANUAL_LOT_SIZE_PERCENTAGE",OBJPROP_TEXT,"Risk % : "+DoubleToString(LotRiskInput,2)+"%");
     ObjectSetString(0,SystemPanelTag+"MANUAL_SL_PRICE",OBJPROP_TEXT,"SL @ "+DoubleToString(SLInputPrice,Digits()));
     ObjectSetString(0,SystemPanelTag+"MANUAL_TP_PRICE",OBJPROP_TEXT,"TP @ "+DoubleToString(TPInputPrice,Digits()));
     ObjectSetString(0,SystemPanelTag+"MANUAL_TYPE_SELL_LIMIT_PRICE",OBJPROP_TEXT,"@ "+DoubleToString(SellPendingInput,Digits()));
     ObjectSetString(0,SystemPanelTag+"MANUAL_TYPE_BUY_LIMIT_PRICE",OBJPROP_TEXT,"@ "+DoubleToString(BuyPendingInput,Digits()));
     }
  double GetRiskBase()
  {
  if(SATP_LOT_AMOUNT==lot_amount_balance) return(AccountBalance());
  if(SATP_LOT_AMOUNT==lot_amount_equity) return(AccountEquity());
  if(SATP_LOT_AMOUNT==lot_amount_free_margin) return(AccountFreeMargin());
  return(0);
  }
void CalculateLots()
     {
     //tick value for one lot 
     double tvol=SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_VALUE);
     if(tvol==0) tvol=TVOL;
     if(tvol!=0) TVOL=tvol;
     //margin initial for one lot
     double mari=MarketInfo(Symbol(),MODE_MARGINREQUIRED);
     if(mari==0) mari=MARI;
     if(mari!=0) MARI=mari;
     //valid values 
     if(mari!=0&&tvol!=0)
     {
     //if set 
       if(LotRiskInput!=0&&LotSizeInput!=0)
       {
       //if mode is static lot 
         if(ACTUAL_SATP_LOT_MODE==lot_mode_static)
         {
         LotRiskInput=0;
         //find rix
           double margin_used=LotSizeInput*mari;
           double amount_unit=((GetRiskBase()/100));           
           if(amount_unit!=0) LotRiskInput=margin_used/amount_unit;
         }
       //if mode is margin risked lot 
         if(ACTUAL_SATP_LOT_MODE==lot_mode_risk)
         {
         LotSizeInput=0;
         //find lot 
           double amount_unit=((GetRiskBase()/100));
           double rix_amount=amount_unit*LotRiskInput;
           if(rix_amount!=0) LotSizeInput=rix_amount/mari;
         }       
       }
     //if set ends here 
     //if none is set - from load
       if(LotRiskInput==0&&LotSizeInput==0)
       {
       //if mode is static lot 
         if(ACTUAL_SATP_LOT_MODE==lot_mode_static)
         {
         LotSizeInput=RiskOrLot;
         LotRiskInput=0;
         //find rix
           double margin_used=LotSizeInput*mari;
           double amount_unit=((GetRiskBase()/100));           
           if(amount_unit!=0) LotRiskInput=margin_used/amount_unit;
         }
       //if mode is margin risked lot 
         if(ACTUAL_SATP_LOT_MODE==lot_mode_risk)
         {
         LotRiskInput=RiskOrLot;
         LotSizeInput=0;
         //find lot 
           double amount_unit=((GetRiskBase()/100));
           double rix_amount=amount_unit*LotRiskInput;
           if(rix_amount!=0) LotSizeInput=rix_amount/mari;
         }
       }
     //if none is set - from load ends here  
     //split 
       LotInstant=0;
       LotPending=0;
       if(LotSizeInput>0)
       {
       LotInstant=FindLotPerc(LotSizeInput,InstantLotPercentage,Symbol());
       LotPending=FindLotPerc(LotSizeInput,PendingLotPercentage,Symbol());
       LotInstant=CheckLot(Symbol(),LotInstant);
       LotPending=CheckLot(Symbol(),LotPending);
       }
     //split 
     }
     //valid values ends here 
     }
     //calculate lots ends here 
};

satp SATP;

//CHECK LOT 
double CheckLot(string symbol,double lot)
{
double returnio=lot;
double max_lot=MarketInfo(symbol,MODE_MAXLOT);
double min_lot=MarketInfo(symbol,MODE_MINLOT);
int lot_digits=LotDigits(min_lot);
returnio=NormalizeDouble(returnio,lot_digits);
if(returnio<=min_lot) returnio=min_lot;
if(returnio>=max_lot) returnio=max_lot;
returnio=NormalizeDouble(returnio,lot_digits);
return(returnio);
}
//CHECK LOT ENDS HERE


//Find Lot Digits 
int LotDigits(double lot)
{
int returnio=0;
double digitos=0;
double transfer=lot;
while(transfer<1)
{
digitos++;
transfer=transfer*10;
} 
returnio=(int)digitos;
//Print("Lot ("+lot+") Digits "+digitos+" Returnio "+returnio);
return(returnio);
}
double FindLotPerc(double full_lot,
                   double percentage,
                   string symbol)
{
double returnio=full_lot;
//find lot digits
double minlot=MarketInfo(symbol,MODE_MINLOT); 
double maxlot=MarketInfo(symbol,MODE_MAXLOT);
int lot_digits=LotDigits(minlot);

double unit=full_lot/100;
double perc=unit*percentage;
perc=NormalizeDouble(perc,lot_digits);
if(perc>full_lot) perc=full_lot;
if(perc<minlot) perc=minlot;
if(perc>maxlot) perc=maxlot;

returnio=perc;
return(returnio);
}

void LOAD()
{
PENDING.Set=false;PENDING.Ticket=-1;
string fname=SystemFolder+"\\"+SystemManualSetupFile;
if(FileIsExist(fname)) 
{
int fop=FileOpen(fname,FILE_READ|FILE_BIN);
if(fop!=INVALID_HANDLE)
  {
  FileReadStruct(fop,SATP);
  FileClose(fop);
  SATP.BuyPendingLines=false;
  SATP.SellPendingLines=false;
  }
}
//live trades 
fname=SystemFolder+"\\"+SystemSymbolLiveTradesFile;
if(FileIsExist(fname))
{
int fop=FileOpen(fname,FILE_READ|FILE_BIN);
if(fop!=INVALID_HANDLE)
  {
  FileReadArray(fop,TRD);
  FileClose(fop);
  TRD_TOTAL=ArraySize(TRD);
  TRD_SIZE=TRD_TOTAL;
  Print("Loaded "+IntegerToString(TRD_TOTAL)+" Live Trades");
  //initial monitoring 
    for(int t=0;t<TRD_TOTAL;t++){TRD[t].MonitorIt();}
    int ts=TRD_TOTAL-1;
    for(int t=ts;t>=0;t--)
    {
    if(TRD[t].ToBeRemoved)
      {
      TRD[t]=TRD[TRD_TOTAL-1];
      TRD_TOTAL--;
      }
    }  
  Print("Remaining from Load "+IntegerToString(TRD_TOTAL));
  //initial monitoring 
  }
}
fname=SystemFolder+"\\"+SystemSymbolPendingTradeFile;
if(FileIsExist(fname))
  {
  int fop=FileOpen(fname,FILE_READ|FILE_BIN);
  if(fop!=INVALID_HANDLE)
    {
    FileReadStruct(fop,PENDING);
    FileClose(fop);
    if(PENDING.Set&&PENDING.Ticket!=-1)
      {
      //check if still open 
        PENDING.SelfCheck();
      }
    }
  }
SAVE();
}

//save
void SAVE()
{
reason_to_save=false;
//manual system
string fname=SystemFolder+"\\"+SystemManualSetupFile;
if(FileIsExist(fname)) FileDelete(fname);
int fop=FileOpen(fname,FILE_WRITE|FILE_BIN);
if(fop!=INVALID_HANDLE)
  {
  FileWriteStruct(fop,SATP);
  FileClose(fop);
  }
fname=SystemFolder+"\\"+SystemSymbolLiveTradesFile;
if(FileIsExist(fname)) FileDelete(fname);
if(TRD_TOTAL>0)
  {
  fop=FileOpen(fname,FILE_WRITE|FILE_BIN);
  if(fop!=INVALID_HANDLE)
    {
    FileWriteArray(fop,TRD,0,TRD_TOTAL);
    FileClose(fop);
    }
  }
fname=SystemFolder+"\\"+SystemSymbolPendingTradeFile;
if(FileIsExist(fname)) FileDelete(fname);
fop=FileOpen(fname,FILE_WRITE|FILE_BIN);
  if(fop!=INVALID_HANDLE)
  {
  FileWriteStruct(fop,PENDING);
  FileClose(fop);
  }
}

//live trades structure 
struct live_trades
{
bool ToBeRemoved,IsFromLimitOrder;
ENUM_ORDER_TYPE Type;
double Lot;
int Ticket;
bool BEApplied,Trailing;
double StopLoss,TakeProfit,OpenPrice;
double BEPointPrice;
//constructor 
live_trades(void){IsFromLimitOrder=false;Type=NULL;Lot=0;Ticket=-1;BEApplied=false;Trailing=false;StopLoss=-1;TakeProfit=-1;OpenPrice=-1;BEPointPrice=-1;ToBeRemoved=false;}
//add trade 
void Add(int ticket,bool is_from_limit_order)
{
bool select=OrderSelect(ticket,SELECT_BY_TICKET);
if(select)
  {
  IsFromLimitOrder=is_from_limit_order;
  ToBeRemoved=false;
  Type=(ENUM_ORDER_TYPE)OrderType();
  Lot=OrderLots();
  Ticket=ticket;
  BEApplied=false;
  Trailing=false;
  StopLoss=OrderStopLoss();
  TakeProfit=OrderTakeProfit();
  OpenPrice=OrderOpenPrice();
  BEPointPrice=CalculateBEP();
  }
}
//calculate bep
double CalculateBEP()
{
double size=MathAbs(TakeProfit-OpenPrice)/100;
size=size*SATP_BE_Trigger_Percentage;
if(Type==OP_BUY) size=OpenPrice+size;
if(Type==OP_SELL) size=OpenPrice-size;
size=NormalizeDouble(size,Digits());
return(size);
}
//monitor trade
void MonitorIt()
{
//still active 
  if(!ToBeRemoved)
  {
  //check if its still open 
    bool select=OrderSelect(Ticket,SELECT_BY_TICKET);
    if(select)
    {
    //closed 
    if(OrderCloseTime()!=0)
      {
      ToBeRemoved=true;
      return;
      }
    //closed ends here 
    //still open 
    if(OrderCloseTime()==0)
      {
      //detect change in stop loss 
      if(!IsFromLimitOrder)
      { 
      //if its not an order that came from pending 
        double alter_pending_sl=-1,alter_pending_tp=-1;
        if(OrderStopLoss()!=StopLoss)
        {
        StopLoss=OrderStopLoss();
        if(PENDING.Set&&PENDING.Ticket!=-1){alter_pending_sl=StopLoss;}
        SATP.SLInputPrice=StopLoss;
        SATP.UpdatePanel();
        }
      //detect change in take profit
        if(OrderTakeProfit()!=TakeProfit)
        {
        TakeProfit=OrderTakeProfit();
        if(PENDING.Set&&PENDING.Ticket!=-1){alter_pending_tp=TakeProfit;}
        SATP.TPInputPrice=TakeProfit;
        SATP.UpdatePanel();
        //cancel BEP 
          BEApplied=false;
          Trailing=false;
        //recalculate BEP
          BEPointPrice=CalculateBEP();
        //make sure its still viable , if not use distance from price
          //buy
          if(OrderType()==OP_BUY)
          {
          //buy closes on bid so ,current bid must be < bepoint price for buys !
            if(Bid>=BEPointPrice){BEPointPrice=Bid+actual_safe_distance;}
          }
          //sell
          if(OrderType()==OP_SELL)
          {
          //sell closes on ask so , current ask must be > bepoint price for sells ! 
            if(Ask<=BEPointPrice){BEPointPrice=Ask-actual_safe_distance;}
          }
        }
       //alter pending too 
         if(alter_pending_sl!=-1||alter_pending_tp!=-1)
         {
         if(PENDING.Set&&PENDING.Ticket!=-1)
           {
           PENDING.Modify(alter_pending_sl,alter_pending_tp);
           }
         }
       //alter pending too ends here 
       }
      //if its not an order that came from pending ends here 
      //buy 
        if(OrderType()==OP_BUY)
        {
        //trailing on
          if(BEApplied&&Trailing&&SATP_TRAILING)
          {
          //new sl
          double newsl=Bid-actual_trail_distance;
          newsl=NormalizeDouble(newsl,Digits());
          //if sl better 
            if(newsl>OrderStopLoss())
            {
            //modify
            Modify(newsl,OrderTakeProfit());
            }
          }
        //be not applied ,and active 
          if(!BEApplied&&SATP_BE&&Bid>=BEPointPrice)
          {
          double originaltp=OrderTakeProfit();
          //partial close and get new ticket 
            int new_ticket=CloseTrade(SATP_BE_Portion,OrderLots());
            if(SATP_BE_Portion==100)
            {
            ToBeRemoved=true;
            SATP.OrderCompensationLogicTrigger_PendingTurned=false;
            if(PENDING.Set&&PENDING.Ticket!=-1) PENDING.Delete(); 
            return;
            }
            if(new_ticket!=Ticket&&SATP_BE_Portion!=100&&new_ticket!=-1)
            {
            Ticket=new_ticket;
            //then set new sl break even
            Modify(OpenPrice,originaltp);
            //and activate trailing if on
            if(SATP_TRAILING) Trailing=true;
            if(PENDING.Set&&PENDING.Ticket!=-1) PENDING.Delete();    
            BEApplied=true;        
            return;
            }
          }
        //be not applied ,and active ends here 
        }
      //buy ends her e
      //sell 
        if(OrderType()==OP_SELL)
        {
        //trailing on
          if(BEApplied&&Trailing&&SATP_TRAILING)
          {
          //new sl
          double newsl=Ask+actual_trail_distance;
          newsl=NormalizeDouble(newsl,Digits());
          //if sl better 
            if(newsl<OrderStopLoss())
            {
            //modify
            Modify(newsl,OrderTakeProfit());
            }
          }
        //be not applied ,and active 
          if(!BEApplied&&SATP_BE&&Ask<=BEPointPrice)
          {
          double originaltp=OrderTakeProfit();
          //partial close and get new ticket 
            int new_ticket=CloseTrade(SATP_BE_Portion,OrderLots());
            if(SATP_BE_Portion==100)
            {
            ToBeRemoved=true;
            SATP.OrderCompensationLogicTrigger_PendingTurned=false;
            if(PENDING.Set&&PENDING.Ticket!=-1) PENDING.Delete();
            return;
            }
            if(new_ticket!=Ticket&&SATP_BE_Portion!=100&&new_ticket!=-1)
            {
            Ticket=new_ticket;
            //then set new sl break even
            Modify(OpenPrice,originaltp);
            //and activate trailing if on
            if(SATP_TRAILING) Trailing=true;
            if(PENDING.Set&&PENDING.Ticket!=-1) PENDING.Delete();
            BEApplied=true;    
            return;
            }
          }
        //be not applied ,and active ends here         
        }
      //sell ends here 
      }
    //still open ends here 
    }
  //check if its still open 
  }
//still active ends here 
}
//modify 
void Modify(double new_sl,double new_tp)
{
int atts=0;
bool modi=false,modi_sl=false,modi_tp=false;
bool change_sl=true,change_tp=true;
bool sel=OrderSelect(Ticket,SELECT_BY_TICKET);
if(sel)
{
double original_tp=OrderTakeProfit(),original_sl=OrderStopLoss();
if(new_sl==OrderStopLoss()) change_sl=false;
if(new_tp==OrderTakeProfit()) change_tp=false;
//change sl first 
if(change_sl)
{
atts=0;
modi_sl=false;
while(!modi_sl&&atts<SATP_MODIFY_ATTEMPTS)
 {
 atts++;
 modi_sl=OrderModify(Ticket,0,new_sl,original_tp,0,clrBlack);
 if(!modi_sl&&atts<=SATP_MODIFY_ATTEMPTS) Sleep(SATP_MODIFY_TIMEOUT);
 }
 if(modi_sl) original_sl=new_sl;
}
//change tp
if(change_tp)
{
atts=0;
modi_tp=false;
while(!modi_tp&&atts<SATP_MODIFY_ATTEMPTS)
 {
 atts++;
 modi_tp=OrderModify(Ticket,0,original_sl,new_tp,0,clrBlack);
 if(!modi_tp&&atts<=SATP_MODIFY_ATTEMPTS) Sleep(SATP_MODIFY_TIMEOUT);
 }
}
}
}
//close 
int CloseTrade(double percentage,double lots)
{
int new_ticket=Ticket;
int atts=0;
bool closed=false;
double closelot=FindLotPerc(lots,percentage,Symbol());
if(percentage>=100) closelot=lots;
string order_direction_text="Buy";
double clop=0;
while(!closed&&atts<SATP_CLOSE_ATTEMPTS)
  {
  atts++;
  clop=Bid;
  if(Type==OP_SELL){clop=Ask;order_direction_text="Sell";}
  closed=OrderClose(Ticket,closelot,clop,SATP_SLIPPAGE,clrBlack);
  if(!closed&&atts<=SATP_CLOSE_ATTEMPTS) Sleep(SATP_CLOSE_TIMEOUT);
  }
if(closed&&percentage<100) new_ticket=GTL_Capture_Partial(Symbol(),SATP_MAGIC,new_ticket,true);
           //if telegram is on
             if(telegram_running&&TelegramSignals&&TelegramCloseDeleteInform)
             {
             string text=Symbol()+"["+telegram_tf_for_images+"] Closed ("+DoubleToString(percentage,2)+"%) "+order_direction_text+" #"+IntegerToString(Ticket)+"\nPrice : "+DoubleToString(clop,Digits())+"\nStopLoss : "+DoubleToString(StopLoss,Digits())+"\nTakeProfit : "+DoubleToString(TakeProfit,Digits());
             if(TelegramTitle_ExtraField!="") text=TelegramTitle_ExtraField+"\n"+text;
             TeleStackAdd(TimeLocal(),TelegramScreenshot,text,0);
             }
           //if telegram is on ends here 
return(new_ticket);
}
//close ends here 
};
//live trades structure ends here 
//array 
  live_trades TRD[];
  int TRD_TOTAL=0,TRD_SIZE=0,TRD_STEP=10;
//FUNCTION TO FIND THE TICKET OF THE NEW PARTIAL CLOSE ORDER 
  int GTL_Capture_Partial(string symbol,
                          int magic,
                          int from_ticket,
                          bool with_comment)
  {
  int returnio=-1;
  string mats=IntegerToString(from_ticket);
  int mats_len=StringLen(mats);  
  int ords=OrdersTotal();
  for(int a=0;a<ords;a++)
  {
  bool choose=OrderSelect(a,SELECT_BY_POS,MODE_TRADES);
  if(choose&&OrderSymbol()==Symbol()&&OrderMagicNumber()==magic)
  {
  if(with_comment==true)
    {
    if(GetContinuousNumber(OrderComment(),"#")==mats)
      {
      returnio=OrderTicket();
      break;
      }
    }
  //check magic adn creds ends here 
  }
  }
  return(returnio);
  }
//FUNCTION TO FIND THE TICKET OF THE NEW PARTIAL CLOSE ORDER ENDS HERE 
  string GetContinuousNumber(string feed,string from_character)
  {
  int size=StringLen(feed);
  int from=StringFind(feed,from_character,0);
  string numero="";
  for(int f=from+1;f<size;f++)
  {
  string charactero=StringSubstr(feed,f,1);
  bool valido=false;
  if(charactero=="0"||charactero=="1"||charactero=="2"||charactero=="3"||charactero=="4"||charactero=="5"||charactero=="6"||charactero=="7"||charactero=="8"||charactero=="9")
  {
  valido=true;
  numero=numero+charactero;
  }
  if(valido==false) break;
  }  
  return(numero);
  }
  
  
  //Close All Live Trades 
  void CloseAllLiveTrades()
  {
  SystemBusy=true;
  for(int t=0;t<TRD_TOTAL;t++)
  {
  if(!TRD[t].ToBeRemoved)
    {
    bool s=OrderSelect(TRD[t].Ticket,SELECT_BY_TICKET);
    if(s)
      {
      double l=OrderLots();
      TRD[t].CloseTrade(100,l);
      }
    }
  }
  SATP.OrderCompensationLogicTrigger_PendingTurned=false;
  TRD_TOTAL=0;
  SAVE();
  SystemBusy=false;
  }
  //Close All Live Trades Ends Here 
  
  //pending 
  struct satp_pending
  {
  order_direction Direction;
  int Ticket;
  double OpenPrice,StopLoss,TakeProfit;
  bool Set,WasLimitOrder;
  void SelfCheck()
    {
    if(Set&&Ticket!=-1)
      {
      //check order 
        bool s=OrderSelect(Ticket,SELECT_BY_TICKET);
        if(s)
        {
        //if opened 
          if(OrderType()==OP_BUY||OrderType()==OP_SELL)
          {
          Set=false;
          //if closed 
            //well nothing ...
          //if closed 
          //and still open and not logged 
          if(OrderCloseTime()==0)
            {
            int logged=-1;
            for(int t=0;t<TRD_TOTAL;t++)
               {
               if(TRD[t].Ticket==Ticket)
                 {
                 logged=t;
                 break;
                 }
               }
            if(logged==-1)
              {
              TRD_TOTAL++;
              if(TRD_TOTAL>TRD_SIZE)
                {
                TRD_SIZE+=TRD_STEP;
                ArrayResize(TRD,TRD_SIZE,0);
                }
              TRD[TRD_TOTAL-1].Add(OrderTicket(),WasLimitOrder);
              SATP.OrderCompensationLogicTrigger_PendingTurned=true;
              }
            }
           Ticket=-1; 
          //and still open and not logged ends here 
          SAVE();
          }
        //if opened ends here 
        }
      //check order ends here 
      }
    }
  void Delete()
  {
  if(Set&&Ticket!=-1)
    {
    Set=false;
    string order_direction_text="Buy Pending ";
    if(Direction==od_sell) order_direction_text="Sell Pending ";
    bool del=OrderDelete(Ticket,clrBlack);
           //if telegram is on
             if(telegram_running&&TelegramSignals&&TelegramCloseDeleteInform)
             {
             string text=Symbol()+"["+telegram_tf_for_images+"] Deleted "+order_direction_text+" #"+IntegerToString(Ticket)+"\nPrice : "+DoubleToString(OpenPrice,Digits())+"\nStopLoss : "+DoubleToString(StopLoss,Digits())+"\nTakeProfit : "+DoubleToString(TakeProfit,Digits());
             if(TelegramTitle_ExtraField!="") text=TelegramTitle_ExtraField+"\n"+text;
             TeleStackAdd(TimeLocal(),TelegramScreenshot,text,0);
             }
           //if telegram is on ends here     
    Ticket=-1;
    }
  }
//modify 
void Modify(double new_sl,double new_tp)
{
int atts=0;
bool modi=false,modi_sl=false,modi_tp=false;
bool change_sl=true,change_tp=true;
bool sel=OrderSelect(Ticket,SELECT_BY_TICKET);
if(sel)
{
datetime expe=OrderExpiration();
double op=OrderOpenPrice();
double original_tp=OrderTakeProfit(),original_sl=OrderStopLoss();
if(new_sl==OrderStopLoss()||new_sl==-1) change_sl=false;
if(new_tp==OrderTakeProfit()||new_tp==-1) change_tp=false;
//change sl first 
if(change_sl)
{
atts=0;
modi_sl=false;
while(!modi_sl&&atts<SATP_MODIFY_ATTEMPTS)
 {
 atts++;
 modi_sl=OrderModify(Ticket,op,new_sl,original_tp,expe,clrBlack);
 if(!modi_sl&&atts<=SATP_MODIFY_ATTEMPTS) Sleep(SATP_MODIFY_TIMEOUT);
 }
 if(modi_sl) original_sl=new_sl;
}
//change tp
if(change_tp)
{
atts=0;
modi_tp=false;
while(!modi_tp&&atts<SATP_MODIFY_ATTEMPTS)
 {
 atts++;
 modi_tp=OrderModify(Ticket,op,original_sl,new_tp,expe,clrBlack);
 if(!modi_tp&&atts<=SATP_MODIFY_ATTEMPTS) Sleep(SATP_MODIFY_TIMEOUT);
 }
}
}
}  
  };
  satp_pending PENDING;
  //pending 
  



  //Controller 
    //JC_ => CTFXEW CONTROL _ 
    //Switch for Date Control
      bool CTFXEW_CONTROL_DATE=false;
      datetime JC_Expiration=D'28.03.2020';
      string JC_MSG_DATE="Trial Expired ! ";//error message 
    //Switch for Account # Control 
      bool CTFXEW_CONTROL_ACCOUNT=false;
      int JC_Account=0000;
      string JC_MSG_ACCOUNT="Invalid Account #.";//error message 
    //Switch for UserName - usually not needed
      bool CTFXEW_CONTROL_USER=false;
      string JC_user_name="";
      string JC_user_surname="";
      string JC_MSG_NAME="Invalid User .";//error message 
    //Switch for Broker   - usually not needed 
      bool CTFXEW_CONTROL_BROKER=false;
      string JC_Broker="";
      string JC_MSG_BROKER="Broker Not Supported .";//error message
    //time in minutes between checks 
      int JC_MINUTES=600;//10 hours 
  //ignore these 
  bool MASTER_JC_CONTROL=false;
  string MASTER_JC_NOTES="";
  datetime MASTER_JC_NEXT_C=0;
  
void CreateDemoNote()
{
ObjectsDeleteAll(0,"MQLNOTE_");
string message="Demo until "+TimeToString(JC_Expiration,TIME_DATE);
int sizex=(int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0)/4;
int posx=(int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS,0)/2;
HS_Create_Btn(0,0,"MQLNOTE_!",sizex,20,posx,0,"Arial",12,clrDarkRed,clrRed,BORDER_RAISED,clrWhite,ALIGN_CENTER,message,false,false);
}
//controller 
struct ctfxew_controller
{
bool valid;
string notes;
datetime next_checktime;
};
ctfxew_controller JCC()
{
ctfxew_controller returnio;
returnio.valid=false;
returnio.notes="ok";
returnio.next_checktime=TimeLocal()+JC_MINUTES*60;
bool r_date=true;
bool r_account=true;
bool r_name=true;
bool r_broker=true;

if(CTFXEW_CONTROL_DATE==true)
{
datetime t1=TimeCurrent();
datetime t2=TimeLocal();
datetime t3=Time[0];
if(t1>=JC_Expiration||t2>=JC_Expiration||t3>=JC_Expiration) r_date=false; 
}

if(CTFXEW_CONTROL_ACCOUNT==true)
{
if(AccountNumber()!=JC_Account) r_account=false;
}

if(CTFXEW_CONTROL_USER==true)
{
string zeuser=AccountName();
if(StringFind(zeuser,JC_user_name,0)==-1||StringFind(zeuser,JC_user_surname,0)==-1) r_name=false;
}

if(CTFXEW_CONTROL_BROKER==true)
{
string brok=AccountCompany();
if(StringFind(brok,JC_Broker,0)==-1) r_broker=false;
}

if(r_date==false) returnio.notes=JC_MSG_DATE;
if(r_name==false) returnio.notes+=JC_MSG_NAME;
if(r_account==false) returnio.notes+=JC_MSG_ACCOUNT;
if(r_broker==false) returnio.notes+=JC_MSG_BROKER;

if(r_date&&r_account&&r_name&&r_broker) returnio.valid=true;

return(returnio);
}

void CreateHLine(long cid,int subw,string name,double price,color col,int wid,ENUM_LINE_STYLE style,bool selectable)
{
bool obji=ObjectCreate(cid,name,OBJ_HLINE,subw,0,price);
ObjectSetInteger(cid,name,OBJPROP_WIDTH,wid);
ObjectSetInteger(cid,name,OBJPROP_COLOR,col);
ObjectSetInteger(cid,name,OBJPROP_BACK,false);
ObjectSetInteger(cid,name,OBJPROP_STYLE,style);
ObjectSetInteger(cid,name,OBJPROP_SELECTABLE,selectable);
}
void UpdateHline(long cid,string name,double price)
{
ObjectSetDouble(cid,name,OBJPROP_PRICE,price);
}
//CREATE BTN OBJECT
  void HS_Create_Btn(long cid,
                     int subw,
                     string name,
                     int sx,
                     int sy,
                     int px,
                     int py,
                     string font,
                     int fontsize,
                     color bck_col,
                     color brd_col,
                     ENUM_BORDER_TYPE brd_type,
                     color txt_col,
                     ENUM_ALIGN_MODE align,
                     string text,
                     bool selectable,
                     bool back)  
  {
  bool obji=ObjectCreate(cid,name,OBJ_BUTTON,subw,0,0);
  if(obji)
    {
    ObjectSetString(0,name,OBJPROP_FONT,font);
    ObjectSetInteger(0,name,OBJPROP_ALIGN,align);
    ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fontsize);
    ObjectSetInteger(0,name,OBJPROP_XSIZE,sx);
    ObjectSetInteger(0,name,OBJPROP_YSIZE,sy);
    ObjectSetInteger(0,name,OBJPROP_XDISTANCE,px);
    ObjectSetInteger(0,name,OBJPROP_YDISTANCE,py);
    ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bck_col);
    ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,brd_col);
    ObjectSetInteger(0,name,OBJPROP_COLOR,txt_col);
    ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,brd_type);
    ObjectSetInteger(0,name,OBJPROP_SELECTABLE,selectable);
    ObjectSetInteger(0,name,OBJPROP_BACK,back);
    ObjectSetString(0,name,OBJPROP_TEXT,text);
    }
  }                   
//CREATE BTN OBJECT ENDS HERE   
//CREATE INPUT OBJECT
  void HS_Create_Edit(long cid,
                     int subw,
                     string name,
                     int sx,
                     int sy,
                     int px,
                     int py,
                     string font,
                     int fontsize,
                     color bck_col,
                     color brd_col,
                     ENUM_BORDER_TYPE brd_type,
                     color txt_col,
                     ENUM_ALIGN_MODE align,
                     string text,
                     bool selectable,
                     bool readonly,
                     bool back)  
  {
  bool obji=ObjectCreate(cid,name,OBJ_EDIT,subw,0,0);
  if(obji)
    {
    ObjectSetString(0,name,OBJPROP_FONT,font);
    ObjectSetInteger(0,name,OBJPROP_ALIGN,align);
    ObjectSetInteger(0,name,OBJPROP_FONTSIZE,fontsize);
    ObjectSetInteger(0,name,OBJPROP_XSIZE,sx);
    ObjectSetInteger(0,name,OBJPROP_YSIZE,sy);
    ObjectSetInteger(0,name,OBJPROP_XDISTANCE,px);
    ObjectSetInteger(0,name,OBJPROP_YDISTANCE,py);
    ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bck_col);
    ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,brd_col);
    ObjectSetInteger(0,name,OBJPROP_COLOR,txt_col);
    ObjectSetInteger(0,name,OBJPROP_BORDER_TYPE,brd_type);
    ObjectSetInteger(0,name,OBJPROP_SELECTABLE,selectable);
    ObjectSetInteger(0,name,OBJPROP_READONLY,readonly);
    ObjectSetInteger(0,name,OBJPROP_BACK,back);
    ObjectSetString(0,name,OBJPROP_TEXT,text);
    }
  }                   
//CREATE BTN OBJECT ENDS HERE 


//Period to Timeframe 
ENUM_TIMEFRAMES PeriodToTF(int period)
{
if(period==1) return(PERIOD_M1);
if(period==5) return(PERIOD_M5);
if(period==15) return(PERIOD_M15);
if(period==30) return(PERIOD_M30);
if(period==60) return(PERIOD_H1);
if(period==240) return(PERIOD_H4);
if(period==1440) return(PERIOD_D1);
if(period==10080) return(PERIOD_W1);
if(period==43200) return(PERIOD_MN1);
return(PERIOD_CURRENT);
}
int TFToPeriod(ENUM_TIMEFRAMES tf)
{
if(tf==PERIOD_CURRENT) return(Period());
if(tf==PERIOD_M1) return(1);
if(tf==PERIOD_M5) return(5);
if(tf==PERIOD_M15) return(15);
if(tf==PERIOD_M30) return(30);
if(tf==PERIOD_H1) return(60);
if(tf==PERIOD_H4) return(240);
if(tf==PERIOD_D1) return(1440);
if(tf==PERIOD_W1) return(10080);
if(tf==PERIOD_MN1) return(43200);
return(Period());
}
//Timeframe To String 
string TFtoString(ENUM_TIMEFRAMES TF)
{
string returnio="";
if(TF==PERIOD_M1) returnio="M1";
if(TF==PERIOD_M5) returnio="M5";
if(TF==PERIOD_M15) returnio="M15";
if(TF==PERIOD_M30) returnio="M30";
if(TF==PERIOD_H1) returnio="H1";
if(TF==PERIOD_H4) returnio="H4";
if(TF==PERIOD_D1) returnio="D1";
if(TF==PERIOD_W1) returnio="W1";
if(TF==PERIOD_MN1) returnio="MN1";
return(returnio);
}
 
  
  //Controller Ends Here 
  
  //REMOVAL MONITOR SYSTEM
enum REMOVAL_METHOD
{
REM_PROGRAM_REMOVED_ITSELF=0,//Program Removed ItSelf
REM_USER_REMOVED_PROGRAM=1,//User Removed Program
REM_RECOMPILED=2,//Code Recompiled
REM_SYMBOL_OR_TF_CHANGE=3,//Symbol Or TF Change
REM_CHART_CLOSED=4,//Chart Closed
REM_USER_CHANGED_INPUTS=5,//User Changed Inputs
REM_ACCOUNT_CHANGE_RECONNECTION=6,//Account Change / Reconnect
REM_TEMPLATE_APPLIED=7,//Template Application Removal
REM_INIT_FAILED=8,//Initialization Failed
REM_TERMINAL_CLOSED=9,//Terminal Closed
REM_UNKNOWN=10//Unknown
};
struct REMOVAL_MONITOR
{
REMOVAL_METHOD RemovalReason;
datetime RemovalTime;
REMOVAL_MONITOR(void){RemovalReason=REM_UNKNOWN;RemovalTime=0;}
void Set(int reason,datetime time){RemovalReason=(REMOVAL_METHOD)reason;RemovalTime=time;}
void Load(string folder,string name)
     {
     string fname=folder+"\\"+name;
     if(FileIsExist(fname))
       {
       int fop=FileOpen(fname,FILE_READ|FILE_BIN);
       if(fop!=INVALID_HANDLE)
         {
         FileReadStruct(fop,this);
         FileClose(fop);
         }
       }
     }
void Save(string folder,string name)
     {
     string fname=folder+"\\"+name;
     if(FileIsExist(fname)) FileDelete(fname);
     int fop=FileOpen(fname,FILE_WRITE|FILE_BIN); 
     if(fop!=INVALID_HANDLE)
       {
       FileWriteStruct(fop,this);
       FileClose(fop);
       }
     }
};
REMOVAL_MONITOR REM;
string REM_Folder="REMTEST",REM_File="_REM.rem";
//REMOVAL MONITOR SYSTEM ENDS HERE 

//SERVER CHECKING ---
//URL ENCODE 
string UrlEncode(string in)
{
string returnio=in;
//replace %
int rep=StringReplace(returnio,"%","%25");
//space
rep=StringReplace(returnio," ","%20");
//!
rep=StringReplace(returnio,"!","%21");
//@
rep=StringReplace(returnio,"@","%40");
//#
rep=StringReplace(returnio,"#","%23");
//$
rep=StringReplace(returnio,"$","%24");
//^
rep=StringReplace(returnio,"^","%CB%86");
//&
rep=StringReplace(returnio,"&","%26");
//*
rep=StringReplace(returnio,"*","%2A");
//(
rep=StringReplace(returnio,"(","%28");
//)
rep=StringReplace(returnio,")","%29");
//-
rep=StringReplace(returnio,"-","%2D");
//+
rep=StringReplace(returnio,"+","%2B");
//:
rep=StringReplace(returnio,":","%3A");
//;
rep=StringReplace(returnio,";","%3B");
//"
rep=StringReplace(returnio,"\"","%22");
//'
rep=StringReplace(returnio,"'","%27");
//?
rep=StringReplace(returnio,"?","%3F");
//<
rep=StringReplace(returnio,"<","%3C");
//>
rep=StringReplace(returnio,">","%3E");
//.
rep=StringReplace(returnio,".","%2E");
//,
rep=StringReplace(returnio,",","%2C");
///
rep=StringReplace(returnio,"/","%2F");
//\
rep=StringReplace(returnio,"\\","%5C");
return(returnio);
}
//URL ENCODE ENDS HERE 

//REQUEST CODE 
enum wr_type
{
wr_get=0,//GET
wr_post=1//POST
};
string WR_REQUEST(wr_type request_type,string url,string &params[],string type,string user_agent,string cookie,string referer,uint timeout)
{
string response="not sent";
string headers="";
/*
for headers , in type string include header descriptor (e.g. Content-Type:)
              in user agent string include user agent descriptor (e.g. user-agent:)
*/
if(type!=NULL) headers=type;
if(user_agent!=NULL) headers=headers+"\r\n"+user_agent;
char post[],result[];
int res;
string target_url=url;
string specs="";
//fill specs if they exist 
int params_total=ArraySize(params);
bool noparams=false;
if(params_total==1&&params[0]=="") noparams=true;
if(noparams==false)
{
for(int fp=0;fp<params_total;fp++)
{
specs=specs+params[fp];
if(fp<params_total-1) specs=specs+"&";
}
}
if(request_type==wr_get&&noparams==false) target_url=target_url+"?"+specs;
char data[];
int data_size=0;
int slen=StringLen(specs);
if(request_type==wr_post) data_size=StringToCharArray(specs,data,0,slen,CP_UTF8);
ResetLastError();
string req_string="GET";
if(request_type==wr_post) req_string="POST";
res=WebRequest(req_string,target_url,cookie,referer,timeout,data,data_size,result,headers);
if(res==-1)
{
Print("Error in WebRequest. Error code  =",GetLastError());
MessageBox("Add the address '"+url+"' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION);
}
else
{
//PrintFormat("The file has been successfully loaded, File size =%d bytes.",ArraySize(result));
int tit=ArraySize(result)-1;
string html="";
for(int xx=0;xx<=tit;xx++)
{
html=html+CharToStr(result[xx]);
}
response=html;
}  
return(response);
ArrayFree(result);
}
//REQUEST CODE ENDS HERE 

bool CheckEmail()
{
if(email=="") return(false);
if(StringFind(email,"@",0)==-1) return(false);
if(StringFind(email,".",0)==-1) return(false);
//request
  string url="http://prenatal.com/wp-json";
  string params[];
  string user_agent="user-agent:Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36 OPR/65.0.3467.62";
  string response=WR_REQUEST(wr_get,url,params,"Content-Type: application/x-www-form-urlencoded",user_agent,NULL,"https://www.google.com",5000);
  //find
    int found=StringFind(response,email,0);
    if(found==-1) return(false);
    if(found!=-1)
    {
    //find accounts 
    int findb=StringFind(response,"}",found);
    if(findb<found) return(false);
    string substring=StringSubstr(response,found,(findb-found));
    int rep=StringReplace(substring,email,"");
    string ca=IntegerToString(AccountNumber());
    if(StringFind(substring,ca,0)==-1) return(false);
    if(StringFind(substring,ca,0)!=-1) return(true);
    }
  //find 
//request
return(false); 
}
//SERVER CHECKING --- 

//TELEGRAM PARTS : 
class CMyBot: public CCustomBot
  {
public:
   void Response(void)
     {
      for(int i=0; i<m_chats.Total(); i++)
        {
         CCustomChat *chat=m_chats.GetNodeAtIndex(i);
         //SendMessage(chat.m_id,"Update "+TimeToString(TimeCurrent(),TIME_DATE|TIME_MINUTES|TIME_SECONDS));
         //--- if the message is not processed
         if(!chat.m_new_one.done)
           {
            chat.m_new_one.done=true;
            Print("ID : "+IntegerToString(chat.m_id));
            SendMessage(chat.m_id,TelegramSignalStart);
           }
        }
     }
  void GetIDS(long &arr[],int &arr_total,int &arr_size,int &arr_step)
  {
  Print("M CHATS : "+IntegerToString(m_chats.Total()));
      for(int i=0; i<m_chats.Total(); i++)
        {
         CCustomChat *chat=m_chats.GetNodeAtIndex(i);
         arr_total++;
         if(arr_total>arr_size)
         {
         arr_size=arr_size+arr_step;
         ArrayResize(arr,arr_size,0);
         }
         arr[arr_total-1]=chat.m_id;
        }  
  }
 
  };

//---
CMyBot bot;
int getme_result;

//user structure - for signals 
long telegram_chat_ids[];
int telegram_chats_total=0;
int telegram_chats_size=0;
int telegram_chats_step=10;
bool telegram_running=false;
string telegram_tf_for_images="";
string telegram_folder_for_images="";
long channel_post_id=0;
//start telegram service and get id's 
  void StartTelegramService()
  {
  telegram_running=true;
//--- set token
  bot.Token(InpToken);
//--- check token
  getme_result=bot.GetMe();
  if(getme_result!=0) telegram_running=false;
  if(telegram_running==false) Alert("Could not start telegram service!");
  if(telegram_running)
  {
  //bot.SendMessage(UserID,TelegramSignalStart+" "+Symbol()); //enable this if y
  //transform tf to period 
    ENUM_TIMEFRAMES thistf=PeriodToTF(Period());
    telegram_tf_for_images=TFtoString(thistf);
    telegram_folder_for_images=SystemFolder+"\\TelegramScreenshots\\";
    //format id for channel messages
      string ids="-100"+ChannelStringID;
      long idl=(long)StringToInteger(ids);
      channel_post_id=idl;
      if(idl>=0)
      {
      telegram_running=false;
      channel_post_id=0;
      }
    //format id for channel messages ends here 
  }
  }
//start telegram service and get id's ends here 

struct telegram_notification
{
datetime ToSend;//Time to send it (delay is used to calculate)
bool Sent,HasPhoto;
string Text,ImageLocation;
telegram_notification(void){ToSend=LONG_MAX;Sent=false;HasPhoto=false;Text=NULL;ImageLocation=NULL;}
~telegram_notification(void){ToSend=LONG_MAX;Sent=false;HasPhoto=false;Text=NULL;ImageLocation=NULL;}
};
telegram_notification TeleStack[];
int TeleStackTotal=0,TeleStackSize=0,TeleStackStep=10;//
void TeleStackAdd(datetime now,
                  bool take_photo,
                  string text,
                  int seconds_delay)
                  {
                  TeleStackTotal++;
                  if(TeleStackTotal>TeleStackSize)
                    {
                    TeleStackSize+=TeleStackStep;
                    ArrayResize(TeleStack,TeleStackSize,0);
                    }
                  //if take photo 
                    bool has_photo=false;
                    string image_location="";
                    if(take_photo)
                    {
                      ChartNavigate(0,CHART_BEGIN,0);
                      int wid=screenie_x;
                      int hei=screenie_y;
                      string screenie=telegram_folder_for_images+"\\"+Symbol()+"_"+telegram_tf_for_images+"_.bmp";
                      if(FileIsExist(screenie)==true) FileDelete(screenie);
                      //loop until file is full 
                      ChartScreenShot(0,screenie,wid,hei,screen_align);
                      bool exist=false,avail=false;
                      while(exist==false||avail==false)
                      {
                      exist=FileIsExist(screenie);
                      int fop=INVALID_HANDLE;
                      if(exist) fop=FileOpen(screenie,FILE_READ);
                      if(fop!=INVALID_HANDLE)
                        {
                        avail=true;
                        FileClose(fop);
                        } 
                      }
                      //open it and save it again 
                      ResourceCreate("SeV",screenie);
                      FileDelete(screenie);
                      ResourceSave("Sev",screenie);
                      ResourceFree("Sev");          
                      image_location=screenie;
                      has_photo=true;              
                    }
                  //if take photo ends here 
                  TeleStack[TeleStackTotal-1].HasPhoto=has_photo;
                  TeleStack[TeleStackTotal-1].ImageLocation=image_location;
                  TeleStack[TeleStackTotal-1].Text=text;
                  TeleStack[TeleStackTotal-1].Sent=false;
                  TeleStack[TeleStackTotal-1].ToSend=(datetime)(now+seconds_delay);
                  }
void TeleStackMonitor(datetime now)
                  {
                  bool any_deletions=false;
                  int ts=TeleStackTotal-1;
                  for(int s=ts;s>=0;s--)
                     {
                     //check for sending 
                       if(now>=TeleStack[s].ToSend&&TeleStack[s].Sent==false)
                       {
                       bot.SendMessage(channel_post_id,TeleStack[s].Text,NULL,false,false);
                       //if photo too
                         if(TeleStack[s].HasPhoto)
                           {
                           string pid="";
                           bool photo_sent=bot.SendPhoto(pid,channel_post_id,TeleStack[s].ImageLocation,NULL,false,1000);
                           if(photo_sent) FileDelete(TeleStack[s].ImageLocation);
                           }
                       TeleStack[s].Sent=true;
                       any_deletions=true;
                       TeleStack[s]=TeleStack[TeleStackTotal-1];
                       TeleStackTotal--;
                       continue;
                       }
                     //check for sending ends here 
                     }
                  }

//TELEGRAM PARTS : ENDS HERE 
