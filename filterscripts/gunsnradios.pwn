#include <a_samp>
#include <zcmd>
#define FILTERSCRIPT
// Feito por Davidavida70 =)
public OnFilterScriptInit()
{
    print("=)");
    return 1;
}

CMD:tec(playerid,params[])
{
    GivePlayerWeapon(playerid, 32, 800);
    return 1;
}

CMD:m4(playerid,params[])
{
    GivePlayerWeapon(playerid, 31, 400);
    return 1;
}

CMD:sniper(playerid,params[])
{
    GivePlayerWeapon(playerid, 34, 100);
    return 1;
}

CMD:colete(playerid,params[])
{
    SetPlayerArmour(playerid, 100.0);
    return 1;
}

CMD:007(playerid,params[])
{
    GivePlayerWeapon(playerid, 23, 200);
    return 1;
}

CMD:granada(playerid,params[])
{
    GivePlayerWeapon(playerid, 16, 12);
    return 1;
}

CMD:spas(playerid,params[])
{
    GivePlayerWeapon(playerid, 27, 150);
    return 1;
}
    
CMD:flores(playerid,params[])
{
    GivePlayerWeapon(playerid, 14, 1);
    return 1;
}

CMD:ak(playerid,params[])
{
    GivePlayerWeapon(playerid, 30, 400);
    return 1;
}

CMD:camera(playerid,params[])
{
    GivePlayerWeapon(playerid, 43, 20);
    return 1;
}

CMD:jetpack(playerid,params[])
{
    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USEJETPACK);
    return 1;
}

CMD:jpsp(playerid,params[])
{
    PlayAudioStreamForPlayer(playerid, "https://player.xcast.com.br/proxy/10668");
    SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Jovem Pan FM SP 100.9");
    return 1;
}

CMD:deagle(playerid,params[])
{
    GivePlayerWeapon(playerid, 24, 200);
    return 1;
}

CMD:satchelc(playerid,params[])
{
    GivePlayerWeapon(playerid, 39, 5);
    return 1;
}

CMD:lanchamas(playerid,params[])
{
    GivePlayerWeapon(playerid, 37, 500);
    return 1;
}

CMD:serraeletrica(playerid,params[])
{
    GivePlayerWeapon(playerid, 9, 1);
    return 1;
}

CMD:mixfm(playerid,params[])
{
    PlayAudioStreamForPlayer(playerid, "https://playerservices.streamtheworld.com/api/livestream-redirect/MIXFM_SAOPAULO.mp3");
    SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Mix FM SP 106.3");
    return 1;
}

CMD:transfmrio(playerid,params[])
{
    PlayAudioStreamForPlayer(playerid, "https://playerservices.streamtheworld.com/api/livestream-redirect/RT_RJ.mp3");
    SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Transam�rica FM Rio 101.3");
    return 1;
}

CMD:stopr(playerid,params[])
{
    StopAudioStreamForPlayer(playerid);
    SendClientMessage(playerid, 0x4D00C1FF, "R�dio Desligada.");
    return 1;
}

CMD:novabrasil(playerid,params[])
{
    PlayAudioStreamForPlayer(playerid, "https://playerservices.streamtheworld.com/api/livestream-redirect/NOVABRASIL_SP.mp3");
    SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Nova Brasil FM 89.7");
    return 1;
}

CMD:antena1(playerid,params[])
{
    PlayAudioStreamForPlayer(playerid, "https://antenaone.crossradio.com.br/stream/2/");
    SendClientMessage(playerid, 0x4D00C1FF, "Tocando agora: Antena 1 FM");
    return 1;
}
