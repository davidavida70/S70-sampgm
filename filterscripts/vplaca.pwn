// FilterScript Alterar Placa do VeÃ­culo

#include <a_samp>
#include <zcmd>

#define plaquinha 70
#define Vermelho 	0xFFFF0000

new Float: X, Float: Y, Float: Z;

CMD:alterarplaca(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, Vermelho, "{FF0000}[ERRO]: {FFFFFF}Você não está dentro de um veículo!");
    ShowPlayerDialog(playerid, plaquinha, DIALOG_STYLE_INPUT, "Alterar Placa", "{FFFFFF}Máximo de Caracteres: 8\n{FFFFFF}Digite a nova placa:", "Confirmar", "Cancelar");
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == plaquinha)
	{
		new String[200], Float:angle;
		if(strlen(inputtext) < 1 || strlen(inputtext) > 8) return SendClientMessage(playerid, Vermelho, "{FF0000}[Erro]: {FFFFFF}A placa tem que ter entre 1 e 8 caracteres.");
		else
		{
			format(String, sizeof(String), "{00FF00}[S70]: {FFFFFF}Placa alterada para {FF0000}%s.", inputtext);
			SendClientMessage(playerid, Vermelho, String);
			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, angle);
			SetVehicleNumberPlate(GetPlayerVehicleID(playerid), inputtext);
			SetVehicleToRespawn(GetPlayerVehicleID(playerid));
			GetPlayerPos(playerid, X, Y, Z);
			SetVehiclePos(GetPlayerVehicleID(playerid), X, Y, Z);
			SetVehicleZAngle(GetPlayerVehicleID(playerid), angle);
			PutPlayerInVehicle(playerid, GetPlayerVehicleID(playerid), 0);
			SetVehiclePos(GetPlayerVehicleID(playerid), X, Y, Z+2);
		}
		return 1;
	}
	return 0;
}

