#pragma semicolon 1
#include <sdktools>

#pragma newdecls required

int money[MAXPLAYERS + 1];

public Plugin myinfo =
{
    name = "Casino :)",
    author = "Hejter (HLmod.ru)",
    version = "0.1",
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_casino", Command_Casino, "!casino <сумма>");
}

public Action Command_Casino(int client, int args)
{
    if (client && IsClientInGame(client) && IsPlayerAlive(client))
    {
        if (args == 1)
        {
            int MoneyOffset = FindSendPropOffs("CCSPlayer", "m_iAccount");
            money[client] = GetEntData(client, MoneyOffset, 4);
            int money_set = GetEntProp(client, Prop_Send, "m_iAccount");
           
            char arg[64];
            GetCmdArg(1, arg, sizeof(arg));
            int amount = StringToInt(arg);
           
            if (money[client] > 0)
            {
                if (amount > 0)
                {
                    if (amount > money[client]) amount = money[client];
                    PrintHintText(client, "Ставка: %d$", amount);
                   
                    int r_case = GetRandomInt(1, 2);
                    switch (r_case)
                    {
                        case 1:
                        {
                            SetEntProp(client, Prop_Send, "m_iAccount", money_set - amount);
                            PrintHintText(client, "Проигрыш: -%d$", amount);
                        }
                       
                        case 2:
                        {
                            SetEntProp(client, Prop_Send, "m_iAccount", money_set + amount*2);
                            PrintHintText(client, "Выигрыш: +%d$", amount);
                        }
                    }
                }
               
                else if (amount < money[client] || amount == money[client]) PrintHintText(client, "Сумма должна быть не меньше 1$");
                else if (!amount) PrintHintText(client, "Неправильная сумма!");
                else if (amount > money[client]) PrintHintText(client, "Сумма не может быть больше наличных!");
                else if (amount < 0 || amount == 0) PrintHintText(client, "Сумма должна быть не меньше 1$");
            }
            else PrintHintText(client, "У тебя нет денег!");
        }
        else ReplyToCommand(client, "Используй: sm_casino <сумма>");
    }
    return Plugin_Handled;
}
