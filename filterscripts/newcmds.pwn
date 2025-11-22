#include <a_samp>
#include <zcmd>

#define FILTERSCRIPT
#define ciano 0x20dfe6FF
#define limao 0xE0FF57FF
#define lradios 1

//70 =)
new gta3;
new gta6;
new track;
new pName[MAX_PLAYER_NAME];

public OnGameModeInit()
{
    gta6 = CreatePickup(1248, 2, 1027.4806,-2179.2910,40.4760, -1);
    gta3 = CreatePickup(1248, 2, 1027.4806,-2178,40.4760, -1);
	track = CreatePickup(1276, 1, 2695.6724,-1704.6514,11.8438, -1);
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if(pickupid == gta6)
    {
        SendClientMessage(playerid, ciano, "Coming in 2026...");
    }
    if(pickupid == gta3)
    {
        SetPlayerHealth(playerid, 100.0);
    }
    else if(pickupid == track)
    {
    	 GetPlayerName(playerid, pName, sizeof(pName));
         SetPlayerPos(playerid,-1403.01,-250.45,1043.53);
         SetPlayerInterior(playerid,7);
         new String[200];
		 format(String, sizeof(String), "%s foi para a 8-track!", pName);
         SendClientMessageToAll(0x00D1D011, String);
         SendClientMessage(playerid, 0x00D1D011, "Digite /sair8track para sair!");
    }
    return 1;
}

CMD:dizeradm(playerid,params[])
{
    new string[128];
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, limao, "Comando somente para administradores!");
    if(isnull(params)) return SendClientMessage(playerid, ciano, "Esqueceu do texto!");
    format(string, sizeof(string), "~b~~h~%s", params);
    GameTextForAll( string, 3000, 1);
    GivePlayerMoney(playerid, 50000);
    return 1;
}

CMD:dizer(playerid,params[])
{
    new string[128];
    if(isnull(params)) return SendClientMessage(playerid, ciano, "Esqueceu do texto!");
    format(string, sizeof(string), "%s", params);
    GameTextForAll( string, 3000, 1);
    return 1;
}

CMD:blindar(playerid,params[])
{
    if(GetPlayerMoney(playerid) < 100000){
        SendClientMessage(playerid, 0x00D1D011, "Preço: 100k");
        return 1;
    }
    new vehicleid = GetPlayerVehicleID(playerid);
    SetVehicleHealth(vehicleid, 3500);
    GivePlayerMoney(playerid, -100000);
    SendClientMessage(playerid, 0x00D1D011, "*1 nokia adicionado*");
    return 1;
}



CMD:deletev(playerid,params[])
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, limao, "Comando somente para administradores!");
    new vehicleid = GetPlayerVehicleID(playerid);
    DestroyVehicle(vehicleid);
    return 1;
}

CMD:radio70(playerid,params[])
{
    PlayAudioStreamForPlayer(playerid, "http://stream.zeno.fm/ru0zuqf8l96vv");
    SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Davidavida70 Sounds");
    return 1;
}

CMD:eduumradio(playerid,params[])
{
    PlayAudioStreamForPlayer(playerid, "http://stream.zeno.fm/5fhrkkylcicvv");
    SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Eduu Sounds");
    return 1;
}

CMD:celular(playerid)
{
    if(!IsPlayerConnected(playerid)) return SendClientMessage(playerid, limao, "Voce não está conectado");
    ShowPlayerDialog(playerid, lradios, DIALOG_STYLE_LIST, "Lista de rádios",
        "listinha do Davidavida70\nEduu Sounds\nPop\nRock\nPop2K\nTropical\n80s\nSmash", "Selecionar","Cancelar");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case lradios:
        {
            if(response)
            {
                switch(listitem)
                {
                    case 0: 
                    {
                        PlayAudioStreamForPlayer(playerid, "http://stream.zeno.fm/ru0zuqf8l96vv");
         	            SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Rádio do Davidavida70");
                    }
                    case 1:
                    {
                        PlayAudioStreamForPlayer(playerid, "http://stream.zeno.fm/5fhrkkylcicvv");
         	            SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Eduu Sounds");
                    }
                    case 2:
                    {
                        PlayAudioStreamForPlayer(playerid, "https://live.hunter.fm/pop_high");
         	            SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Hunter FM Pop");
                    }
                    case 3:
                    {
                        PlayAudioStreamForPlayer(playerid, "https://live.hunter.fm/rock_high");
         	            SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Hunter FM Rock");
                    }
                    case 4:
                    {
                        PlayAudioStreamForPlayer(playerid, "https://live.hunter.fm/pop2k_high");
         	            SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Hunter FM Pop2K");
                    }
                    case 5:
                    {
                        PlayAudioStreamForPlayer(playerid, "https://live.hunter.fm/tropical_high");
         	            SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Hunter FM Tropical");
                    }
                    case 6:
                    {
                        PlayAudioStreamForPlayer(playerid, "https://live.hunter.fm/80s_high");
         	            SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Hunter FM 80s");
                    }
                    case 7:
                    {
                        PlayAudioStreamForPlayer(playerid, "https://live.hunter.fm/smash_high");
         	            SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Hunter FM Smash");
                    }
                }
            }
            return 1;
        }
    }
    return 0;
}
