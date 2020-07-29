# tegi
MT4 Trading Panel for Telegram Groups/Channels

Manual Trading Panel to open/manage orders with a different logic from the classic ones.
- Open Buy/Sell with TP / SL .
- When order is in profit and the distance from the TP is X% from its opening price, it moves the SL to breakeven,closes part of the lot and leaves the remaining
lot to take full TP or breakeven.
- All this processes are sent to telegram groups/chats.


To send trades to Telegram,follow these steps :

Go to MetaTrader4 , 
- click "Tools" ,
- click "Options" , 
- click the tab "ExpertAdvisors" , make sure "Allow WebRequest for listed url is checked" ,double click on an empty row in the table below that , and paste "https://api.telegram.org" without the quotes . click okay ,restart mt4 .


In Telegram :
- find "botfather" 
- create a new bot and copy the bot token
- place the token inside the quotes in line #44 in variable InpToken
- add the bot to your public group/channel as Admin .


- Open your telegram group/channel from the web (not the installed app) because we need to get the token .
- then select the adress bar which will show the link of the channel , it will have a part where theres a "c" followed by a number until a "_"
- copy that number without c and without _
- place it inside the quotes of ChannelStringID in line #43
- recompile , restart MT4 .


