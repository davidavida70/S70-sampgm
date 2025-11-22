#include <a_samp>
#include <a_mysql>
#include <zcmd>
#include <streamer>
#include <sscanf2>
#include "../include/gl_common.inc"
#include "../include/GetVehicleColor.inc"
#include "../include/foreach.inc"

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define cJobless 0xBFBE82FF
#define cCop 0x042891FF
#define cMotoronibus 0x2694DEFF
#define cDetento 0x858585FF
#define LISTA 11
#define chkSENHA 12
#define newSENHA 5
#define NOME 8
#define WRONGP -2
#define escSKIN 77
#define procurados 10
#define falsidade 123
#define dados 3
#define host "localhost" //samp.cdum2a00izev.sa-east-1.rds.amazonaws.com - Exemplo de endereço Amazon RDS, pode ser localhost ou outro.
#define user "root"
#define pass ""
#define db "meuservidor"
#define checkpsize 2.5


new veiculo1[MAX_PLAYERS];
new veiculo2[MAX_PLAYERS];
new numPosse[MAX_PLAYERS];
new MySQL:Conexao;
new bus;
new bus1, bus2;
new crimetruck[MAX_PLAYERS];
new copls1, copls2, copls3, copls4, copls5, copls6, copls7, copls8, copls9;
new copsf1, copsf2, copsf3, copsf4;
new coplv1, coplv2, coplv3, coplv4, coplv5;
new isca;
new policiaLS;
new prisaotimer[MAX_PLAYERS], prisaotimer2[MAX_PLAYERS], prisaotimer3[MAX_PLAYERS];
new uniformeMpolicia, uniformeFpolicia, armasPolicia;
#define MAX_SENHA 125
new jobId[MAX_PLAYERS];
enum playerInfo{
    ID,
    Senha[MAX_SENHA],
    Nivel,
    Estrelas,
    Skin,
    Grana,
    Cargo[70],
    Erros,
    bool:logado,
    bool:trabalhando,
    bool:congelado
};
enum conceInfo{
    vModel,
    vPreco,
    vName[64],
    PlayerText:tdModel,
    PlayerText:tdPreco,
    PlayerText:tdName,

};
new lconceLS[][conceInfo] = {
    {496, 10000, "Blista Compact"},
    {411, 150000, "Infernus"},
    {458, 7400, "Solair"},
    {483, 6000, "Camper"},
    {445, 9500, "Admiral"},
    {522, 100000, "NRG-500"}
};
new pInfo[MAX_PLAYERS][playerInfo];
new idChk[MAX_PLAYERS];
new PlayerText: conceLS[MAX_PLAYERS][20];
main(){
    print("\n---------------------------------------");
	print("      Servidor do Davidavida70 =)");
	print("---------------------------------------\n");
    print("Trocar ip da stream de musica!");
}

public OnGameModeInit(){
    Conexao = mysql_connect(host, user, pass, db);

    if (mysql_errno() != 0){
        print("Nao foi possível conectar ao mysql\n\n");
        SendRconCommand("pause");
    }else{
        print("Mysql conectado!");
        UsePlayerPedAnims(1);
        EnableStuntBonusForAll(1);
        bus1 = AddStaticVehicleEx(437,-147.2776,1123.7859,19.8416,0.1445, 75,59, 40);
        bus2 = AddStaticVehicleEx(437,-141.3650,1115.5614,19.8514,359.8623, 75,59, 40);
        copls1 = AddStaticVehicle(523,1545.9912,-1615.9418,12.9528,270.9079,0,0); copls2 = AddStaticVehicle(523,1545.2556,-1612.0648,12.9503,269.9847,0,0);
        copls3 = AddStaticVehicle(523,1544.9584,-1607.2888,12.9508,271.5052,0,0); copls4 = AddStaticVehicle(596,1565.3047,-1606.0006,13.1027,179.3147,0,1);
        copls5 = AddStaticVehicle(596,1558.0032,-1606.0706,13.1034,179.8607,0,1); copls6 = AddStaticVehicle(596,1572.3684,-1605.9385,13.1028,180.0875,0,1);
        copls7 = AddStaticVehicle(490,1582.1641,-1606.3086,13.5107,180.0232,0,0); copls8 = AddStaticVehicle(490,1589.3317,-1606.0548,13.5102,180.0615,0,0);
        copls9 = AddStaticVehicle(490,1596.9407,-1606.1652,13.5582,180.4552,0,0);
        copsf1 = AddStaticVehicleEx(415,-1605.6688,674.0481,6.9587,180.8148,0,0, -1, 1); // superpoliciaSF1
        copsf2 = AddStaticVehicleEx(415,-1594.2947,674.2325,6.9589,179.8334,0,0, -1, 1); // superpoliciaSF2
        copsf3 = AddStaticVehicle(497,-1680.1487,706.5649,30.7776,89.7895,0,1); // helipoliciaSF1
        copsf4 = AddStaticVehicle(497,-1679.8170,700.1218,30.7757,88.9854,0,1); // helipoliciaSF2
        coplv1 = AddStaticVehicle(598,2255.8242,2443.5017,10.5646,359.9724,0,1); // lvpd1
        coplv2 = AddStaticVehicle(598,2256.1855,2477.7383,10.5664,180.4191,0,1); // lvpd2
        coplv3 = AddStaticVehicle(427,2273.2761,2443.4268,10.9523,359.6781,0,1); // enforcerlvpd1
        coplv4 = AddStaticVehicleEx(521,2282.2075,2476.2136,10.3868,177.6607,0,0, -1, 1); // bikelvpd1 cor preta!
        coplv5 = AddStaticVehicleEx(521,2291.2886,2477.8647,10.3895,180.0363,0,0, -1, 1); // bikelvpd2 cor preta!
        isca = AddStaticVehicle(432,201.4919,1881.8418,17.6571,180.7181,43,0); // rhinoprocurado
        LoadStaticVehiclesFromFile("vehicles/70gm.txt");
        LoadStaticVehiclesFromFile("vehicles/ls_airport.txt");
        LoadStaticVehiclesFromFile("vehicles/sf_airport.txt");
        LoadStaticVehiclesFromFile("vehicles/lv_gen.txt");
        LoadStaticVehiclesFromFile("vehicles/whetstone.txt");
        LoadStaticVehiclesFromFile("vehicles/ls_gen_inner.txt");
        LoadStaticVehiclesFromFile("vehicles/flint.txt");
        LoadStaticVehiclesFromFile("vehicles/red_county.txt");
        LoadStaticVehiclesFromFile("vehicles/ls_gen_outer.txt");
        LoadStaticVehiclesFromFile("vehicles/sf_gen.txt");
        LoadStaticVehiclesFromFile("vehicles/tierra.txt");
        LoadStaticVehiclesFromFile("vehicles/lv_airport.txt");
        bus = CreatePickup(1210, 1, -136.3961, 1116.7656, 20.1966, -1);
        CreatePickup(1274, 1, 605.7740,-1490.8625,14.9207, -1); //conceLS
        policiaLS = CreatePickup(1581, 1, 1547.0686,-1670.1342,13.5671, -1);
        uniformeMpolicia = CreatePickup(1275, 1, 254.1991,76.8481,1003.6406, -1);
        uniformeFpolicia = CreatePickup(1275, 1, 257.7203,77.0741,1003.6406, -1);
        armasPolicia = CreatePickup(1242, 1, 255.0673,65.2765,1003.6406, -1);
        CreatePickup(1242, 1, 1858.5956,-1848.4109,13.5795, -1); //transporte ilegal
        Create3DTextLabel("Transporte ilegal - Aperte Y", 0x008080FF, 1858.5956,-1848.4109,13.6795, 40.0, 0, 1);
        Create3DTextLabel("Venha fazer parte da Polícia!", 0x008080FF, 1547.0686,-1670.1342,13.9971, 40.0, 0, 1);
        Create3DTextLabel("Uniforme masculino", 0x008080FF, 254.1991,76.8481,1003.6996, 25.0, 0, 1);
        Create3DTextLabel("Uniforme feminino", 0x008080FF, 257.7203,77.0741,1003.6996, 25.0, 0, 1);
        Create3DTextLabel("Kit Preparo", 0x008080FF, 255.0673,65.2765,1003.6996, 25.0, 0, 1);
        Create3DTextLabel("Aperte Y para abrir o menu!", 0x008080FF, 605.7740,-1490.8625,14.9907, 40.0, 0, 1);
        Create3DTextLabel("Venha com seu carro e digite /venderveiculo para vendê-lo!", 0x008080FF, -2022.2340,-100.0629,35.1641, 40.0, 0, 1);
        CreateObject(19302, 266.34143, 82.94936, 1001.28192,   0.00000, 0.00000, -89.82000);
        CreateObject(19302, 266.35425, 87.46339, 1001.28192,   0.00000, 0.00000, -89.82000);
    }
    
    return 1;
}

stock criarConta(playerid, const senha[MAX_SENHA]){
    pInfo[playerid][Grana] = 1000;
    pInfo[playerid][Nivel] = 0;
    pInfo[playerid][Skin] = 1;
    pInfo[playerid][Estrelas] = 0;
    pInfo[playerid][trabalhando] = false;
    pInfo[playerid][logado] = true;
    format(pInfo[playerid][Cargo], 70, "desempregado");
    format(pInfo[playerid][Senha], MAX_SENHA, senha);
    idChk[playerid] = 0;
    jobId[playerid] = 0;
    new query[450];

    mysql_format(Conexao, query, sizeof(query), "INSERT INTO contas (nome, senha, skin, grana, cargo, nivel) \
    VALUES ('%s', '%s', %d, %d, '%s', %d)", pName(playerid), pInfo[playerid][Senha],
     pInfo[playerid][Skin], pInfo[playerid][Grana], pInfo[playerid][Cargo], pInfo[playerid][Nivel]); // contas = nome da tabela

    mysql_tquery(Conexao, query);

    printf("Novo(a) jogador(a) no banco de dados: %s", pName(playerid));
}


forward salvarConta(playerid);
public salvarConta(playerid){
    if(pInfo[playerid][logado] == false)
        return 0;  
    pInfo[playerid][Grana] = GetPlayerMoney(playerid);
    if(jobId[playerid] == 3 && pInfo[playerid][trabalhando] == true){} else{
        pInfo[playerid][Skin] = GetPlayerSkin(playerid);
    }
    pInfo[playerid][Nivel] = GetPlayerScore(playerid);
    pInfo[playerid][Estrelas] = GetPlayerWantedLevel(playerid);
    new query[450];

    mysql_format(Conexao, query, sizeof(query), "update contas set skin = %d, grana = %d, cargo = '%s', nivel = %d, estrelas = %d where id = %d;",
    pInfo[playerid][Skin], pInfo[playerid][Grana], pInfo[playerid][Cargo], pInfo[playerid][Nivel], pInfo[playerid][Estrelas], pInfo[playerid][ID]);

    mysql_tquery(Conexao, query);
    return 1;
}

stock compraVeiculo(playerid, vID, Float:vX, Float:vY, Float:vZ, Float:vROT){
    if(pInfo[playerid][logado] == false)
        return 0;
    if(GetPlayerWantedLevel(playerid) != 0){
        SendClientMessage(playerid, 0x8AB7C2FF, "Você está procurado(a), se entregue!");
        return 0;
    }
    else if(numPosse[playerid] < 1){
        new query[450];
        numPosse[playerid]++;
        mysql_format(Conexao, query, sizeof(query), "INSERT INTO veiculos (vID, vX, vY, vZ, vROT, pID, numPosse) \
        VALUES (%d, %f, %f, %f, %f, %d, %d)", vID, vX, vY, vZ, vROT, pInfo[playerid][ID], numPosse[playerid]);

        mysql_tquery(Conexao, query);

        printf("É o veiculo número %d que o id %d adquire. Salvo no banco de dados.", numPosse[playerid], pInfo[playerid][ID]);
        return 1;
    } else{
        SendClientMessage(playerid, 0x8AB7C2FF, "Você não pode ter mais que dois veículos!");
        return 0;
    }

}

stock salvarVeiculo(playerid, vehicleid, numero){
    if(pInfo[playerid][logado] == false)
        return 0;
    if(GetPlayerWantedLevel(playerid) != 0){
        SendClientMessage(playerid, 0x8AB7C2FF, "Você está procurado(a), se entregue!");
        return 0;
    }
    new query[450];
    new Float:vX, Float:vY, Float:vZ, Float:vROT;
    new cor1, cor2;
    GetVehiclePos(vehicleid, vX, vY, vZ);
    GetVehicleZAngle(vehicleid, vROT);
    GetVehicleColor(vehicleid, cor1, cor2);
    new vID = GetVehicleModel(vehicleid);
    mysql_format(Conexao, query, sizeof(query), "update veiculos set vX = %f, vY = %f, vZ = %f, vROT = %f, cor1 = %d, cor2 = %d where pID = %d and vID = %d and numPosse = %d;",
    vX, vY, vZ, vROT, cor1, cor2, pInfo[playerid][ID], vID, numero);
    mysql_tquery(Conexao, query);

    mysql_format(Conexao, query, sizeof(query), "select * from veiculos where pID = %d;", pInfo[playerid][ID]);
    mysql_tquery(Conexao, query, "vLoad", "d", playerid);
    return 1;
}
    

stock liberarDados(playerid){
    pInfo[playerid][ID] = 0;
    pInfo[playerid][Senha][0] = EOS;
    pInfo[playerid][Nivel] = 0;
    pInfo[playerid][Skin] = 0;
    pInfo[playerid][Grana] = 0;
    pInfo[playerid][Estrelas] = 0;
    pInfo[playerid][Cargo][0] = EOS;
    pInfo[playerid][Erros] = 0;
    pInfo[playerid][logado] = false;
    pInfo[playerid][trabalhando] = false;
    pInfo[playerid][congelado] = false;
    veiculo1[playerid] = 0;
    veiculo2[playerid] = 0;
    idChk[playerid] = 0;
    jobId[playerid] = 0;
    numPosse[playerid] = -1;
}

stock pName(playerid){
    new nome[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, nome, sizeof(nome));
    return nome;
}


public OnPlayerRequestClass(playerid, classid){
    pSpawner(playerid);
    return 1;
}

public OnPlayerConnect(playerid){
    new query[450];
    pInfo[playerid][Erros] = 0;
    TogglePlayerSpectating(playerid, 1);
    SetPlayerMapIcon(playerid, 0, 1548.9117,-1675.2977,14.7312, 30, 0, MAPICON_LOCAL);
    SetPlayerMapIcon(playerid, 1, -136.3961,1116.7656,20.1966, 48, 0, MAPICON_GLOBAL);
    SetPlayerMapIcon(playerid, 2, 605.7740,-1490.8625,14.9207, 55, 0, MAPICON_GLOBAL);
    SetPlayerMapIcon(playerid, 3, -2022.2340,-100.0629,35.1641, 19, 0, MAPICON_GLOBAL);
    SetPlayerMapIcon(playerid, 4, 1858.5956,-1848.4109,13.6795, 51, 0, MAPICON_GLOBAL);
    mysql_format(Conexao, query, sizeof(query), "select * from contas where nome = '%s';", pName(playerid));
    mysql_tquery(Conexao, query, "pLoad", "d", playerid);
    return 1;
}

forward pLoad(playerid);
public pLoad(playerid){
    SetPlayerCameraPos(playerid, -57.5039, 1182.0483, 34.9289);
    SetPlayerCameraLookAt(playerid, 69.0936, 1178.4989, 43.9301);
    if(cache_num_rows() != 0){
        new bvindas[55];
        cache_get_value_name(0, "senha", pInfo[playerid][Senha], MAX_SENHA);
        cache_get_value_name(0, "cargo", pInfo[playerid][Cargo], 70);
        cache_get_value_name_int(0, "skin", pInfo[playerid][Skin]);
        cache_get_value_name_int(0, "grana", pInfo[playerid][Grana]);
        cache_get_value_name_int(0, "id", pInfo[playerid][ID]);
        cache_get_value_name_int(0, "nivel", pInfo[playerid][Nivel]);
        cache_get_value_name_int(0, "estrelas", pInfo[playerid][Estrelas]);
        if(strcmp("desempregado", pInfo[playerid][Cargo]) == 0){
            jobId[playerid] = 0;
        }
        else if(strcmp("motoronibus", pInfo[playerid][Cargo]) == 0){
            jobId[playerid] = 1;
        }
        else if(strcmp("detento", pInfo[playerid][Cargo]) == 0){
            jobId[playerid] = 2;
        }
        else if(strcmp("policial", pInfo[playerid][Cargo]) == 0){
            jobId[playerid] = 3;
        }
        format(bvindas, sizeof(bvindas), "Olá, %s! Digite sua senha:", pName(playerid));
        ShowPlayerDialog(playerid, chkSENHA, DIALOG_STYLE_PASSWORD, "Senha", bvindas, "Confirmar", "Sair");
        
	} else{
        new bvindas[55];
        format(bvindas, sizeof(bvindas), "Olá, %s! Crie sua senha:", pName(playerid));
        ShowPlayerDialog(playerid, newSENHA, DIALOG_STYLE_PASSWORD, "Senha", bvindas, "Confirmar", "Sair");
    }
	return 1;
}

forward vLoad(playerid);
public vLoad(playerid){
    if(cache_num_rows() == 1){
        new Float:vX, Float:vY, Float:vZ, Float:vROT;
        new vID, cor1, cor2;
        
        cache_get_value_name_float(0, "vX", vX); cache_get_value_name_float(0, "vY", vY);
        cache_get_value_name_float(0, "vZ", vZ); cache_get_value_name_float(0, "vROT", vROT);
        cache_get_value_name_int(0, "vID", vID); cache_get_value_name_int(0, "numPosse", numPosse[playerid]);
        cache_get_value_name_int(0, "cor1", cor1); cache_get_value_name_int(0, "cor2", cor2);
        vSpawner(playerid, 0, vID, vX, vY, vZ, vROT, cor1, cor2);
        
    } else if(cache_num_rows() == 2){
        new Float:vX, Float:vY, Float:vZ, Float:vROT;
        new vID, cor1, cor2;
        new Float:vX2, Float:vY2, Float:vZ2, Float:vROT2;
        new vID2, cordois1, cordois2;
        cache_get_value_name_float(0, "vX", vX); cache_get_value_name_float(0, "vY", vY);
        cache_get_value_name_float(0, "vZ", vZ); cache_get_value_name_float(0, "vROT", vROT);
        cache_get_value_name_int(0, "vID", vID); cache_get_value_name_int(0, "cor1", cor1);
        cache_get_value_name_int(0, "cor2", cor2);
        vSpawner(playerid, 0, vID, vX,vY,vZ,vROT, cor1, cor2);
        cache_get_value_name_float(1, "vX", vX2); cache_get_value_name_float(1, "vY", vY2);
        cache_get_value_name_float(1, "vZ", vZ2); cache_get_value_name_float(1, "vROT", vROT2);
        cache_get_value_name_int(1, "vID", vID2); cache_get_value_name_int(1, "numPosse", numPosse[playerid]);
        cache_get_value_name_int(1, "cor1", cordois1); cache_get_value_name_int(1, "cor2", cordois2);
        vSpawner(playerid, 1, vID2, vX2,vY2,vZ2,vROT2, cordois1, cordois2);
    } else {
        numPosse[playerid] = -1;
        SendClientMessage(playerid, 0x8AB7C2FF, "Você não tem veículos! Caso queira, visite a Concessionária de Los Santos!");
    }
    return 1;
}

stock vSpawner(playerid, vez, vID, Float:vX, Float:vY, Float:vZ, Float:vROT, cor1, cor2){
    if(vez == 0 && veiculo1[playerid] == 0){
        veiculo1[playerid] = CreateVehicle(vID, vX,vY,vZ,vROT, cor1, cor2, -1);
    } else if(vez == 1 && veiculo2[playerid] == 0){
        veiculo2[playerid] = CreateVehicle(vID, vX,vY,vZ,vROT, cor1, cor2, -1);
    }
    return 1;
}

stock pCargo(playerid, cargo){
    switch(cargo){
        case 0: {format(pInfo[playerid][Cargo], 70, "desempregado"); jobId[playerid] = 0; SetPlayerColor(playerid, cJobless); SetSpawnInfo(playerid, 0, pInfo[playerid][Skin], 12.5354, 1211.0503, 22.5032, 84.9185, 0, 0, 0, 0, 0, 0);}
        case 1: {format(pInfo[playerid][Cargo], 70, "motoronibus"); jobId[playerid] = 1; SetPlayerColor(playerid, cMotoronibus); SetSpawnInfo(playerid, 0, pInfo[playerid][Skin], 12.5354, 1211.0503, 22.5032, 84.9185, 0, 0, 0, 0, 0, 0);}
        case 2: {format(pInfo[playerid][Cargo], 70, "detento");   jobId[playerid] = 2; SetPlayerColor(playerid, cDetento); SetSpawnInfo(playerid, 0, pInfo[playerid][Skin], 263.4595, 76.8951, 1001.0391, 3.4174, 0, 0, 0, 0, 0, 0); SetPlayerInterior(playerid, 6);}
        case 3: {format(pInfo[playerid][Cargo], 70, "policial"); jobId[playerid] = 3; SetPlayerColor(playerid, cCop); SetSpawnInfo(playerid, 0, pInfo[playerid][Skin], 1599.1313, -1636.3346, 13.7188, 3.4174, 0, 0, 0, 0, 0, 0);}
    }
    return cargo;
}

stock pSpawner(playerid){
    new query[450];
    pInfo[playerid][logado] = true;
    TogglePlayerSpectating(playerid, 0); 
    SetSpawnInfo(playerid, 0, pInfo[playerid][Skin], 12.5354, 1211.0503, 22.5032, 84.9185, 0, 0, 0, 0, 0, 0);
    if(jobId[playerid] == 3){
        SetSpawnInfo(playerid, 0, pInfo[playerid][Skin], 1599.1313, -1636.3346, 13.7188, 3.4174, 0, 0, 0, 0, 0, 0);
    }
    else if(jobId[playerid] == 2){
        prisaotimer[playerid] = SetTimerEx("liberarPrisao", 665000, false, "i", playerid);
        PlayAudioStreamForPlayer(playerid, "http://191.254.239.88:7070/toouvindoalguemmechamar.mp3");
        SetPlayerInterior(playerid, 6);
        SetSpawnInfo(playerid, 0, pInfo[playerid][Skin], 263.4595, 76.8951, 1001.0391, 3.4174, 0, 0, 0, 0, 0, 0);
    }
    SetPlayerSkin(playerid, pInfo[playerid][Skin]);
    mysql_format(Conexao, query, sizeof(query), "select * from veiculos where pID = %d;", pInfo[playerid][ID]);
    mysql_tquery(Conexao, query, "vLoad", "d", playerid);
    SpawnPlayer(playerid);
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, pInfo[playerid][Grana]);
    //printf("senha:%s grana: %d id: %d skin: %d", pInfo[playerid][Senha], pInfo[playerid][Grana],
    //pInfo[playerid][ID], pInfo[playerid][Skin]);
    return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
    new errosenha[55];
    new query[150];
    switch(dialogid){
        case newSENHA:{
            if(!response){
                Kick(playerid);
            }
            if(strlen(inputtext) < 6 || strlen(inputtext) > MAX_SENHA || strlen(inputtext) == 0){
                SendClientMessage(playerid, 0x8AB7C2FF, "Senha inválida! A senha deve ser maior que 6 caracteres e menor que 125 caracteres.");
                TogglePlayerSpectating(playerid, 1);
                new bvindas[55];
                format(bvindas, sizeof(bvindas), "Olá, %s! Crie sua senha:", pName(playerid));
                ShowPlayerDialog(playerid, newSENHA, DIALOG_STYLE_PASSWORD, "Senha", bvindas, "Confirmar", "Sair");
            } else{
                new psenha[MAX_SENHA];
                format(psenha, sizeof(psenha), inputtext);
                SendClientMessage(playerid, 0x8AB7C2FF, "Bem-vindo(a)! Digite /ajuda para saber mais sobre o servidor!");
                criarConta(playerid, psenha);
                mysql_format(Conexao, query, sizeof(query), "select * from contas where nome = '%s';", pName(playerid));
                mysql_tquery(Conexao, query, "pLoad", "d", playerid);
            }
            return 1;
        }
        case chkSENHA:{
            if(!response){
                Kick(playerid);
            }
            if(strcmp(inputtext, pInfo[playerid][Senha]) != 0 || strlen(inputtext) == 0){
                if(pInfo[playerid][Erros] >= 3){
                    Kick(playerid);
                }
                pInfo[playerid][Erros]++;
                format(errosenha, sizeof(errosenha), "Senha errada! Tentativa: %d de 3", (pInfo[playerid][Erros]));
                SendClientMessage(playerid, 0x8AB7C2FF, errosenha);
                TogglePlayerSpectating(playerid, 1);
                new bvindas[55];
                format(bvindas, sizeof(bvindas), "Olá, %s! Digite sua senha:", pName(playerid));
                ShowPlayerDialog(playerid, chkSENHA, DIALOG_STYLE_PASSWORD, "Senha", bvindas, "Confirmar", "Sair");
            } else{
                pSpawner(playerid);
            }
            return 1;
        }
        case escSKIN:{
            if(!response) return 1;
            if(strval(inputtext) >= 274 && strval(inputtext) < 289){
                SendClientMessage(playerid, 0x8AB7C2FF, "Skin reservada.");
            }
            else if(strval(inputtext) >= 300){
                SendClientMessage(playerid, 0x8AB7C2FF, "Skin reservada.");
            } else{
                pInfo[playerid][Skin] = strval(inputtext);
            }
            return 1;
        }
        case falsidade:{
            if(!response) return 1;
            switch(listitem){
                case 0:{
                    idChk[playerid] = 4;
                    SetPlayerRaceCheckpoint(playerid, 2, 2597.0774,-1090.7151,69.0694, 0, 0, 0, checkpsize);
                    crimetruck[playerid] = CreateVehicle(456,1865.3422,-1843.9226,13.7501,180.8220,-1, -1, -1);
                    pInfo[playerid][trabalhando] = true;
                    SendClientMessage(playerid, 0x8AB7C2FF, "Entre no caminhão ao lado e faça a entrega!");
                    SetPlayerWantedLevel(playerid, 4);
                }
                case 1:{
                    idChk[playerid] = 5;
                    SetPlayerRaceCheckpoint(playerid, 2, 2800.8401,-1089.8740,30.7694, 0, 0, 0, checkpsize);
                    crimetruck[playerid] = CreateVehicle(414,1864.1305,-1858.2222,13.6747,178.8349,-1,-1, -1);
                    pInfo[playerid][trabalhando] = true;
                    SendClientMessage(playerid, 0x8AB7C2FF, "Entre no caminhão ao lado e faça a entrega!");
                    SetPlayerWantedLevel(playerid, 4);
                }
                case 2:{
                    idChk[playerid] = 6;
                    SetPlayerRaceCheckpoint(playerid, 2, 977.3979,-767.9246,112.2591, 0, 0, 0, checkpsize);
                    crimetruck[playerid] = CreateVehicle(459,1848.3384,-1829.2115,13.6246,73.6432,-1, -1, -1);
                    pInfo[playerid][trabalhando] = true;
                    SendClientMessage(playerid, 0x8AB7C2FF, "Entre na van ao lado e faça a entrega!");
                    SetPlayerWantedLevel(playerid, 4);
                }
            }
            return 1;
        }
    }
    return 0;
}

public OnVehicleDeath(vehicleid, killerid){
    if(vehicleid == crimetruck[killerid]){
        idChk[killerid] = 4;
        DestroyVehicle(vehicleid);
        pInfo[killerid][trabalhando] = false;
        DisablePlayerRaceCheckpoint(killerid);
        SendClientMessage(killerid, 0x8AB7C2FF, "Aceitaram parte do valor pra coisa não ficar feia!");
        GivePlayerMoney(killerid, -7000);
    }
    return 1;
}

public OnPlayerSpawn(playerid){
    idChk[playerid] = 0;
    SetPlayerSkin(playerid, pInfo[playerid][Skin]);
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, pInfo[playerid][Grana]);
    switch(jobId[playerid]){
        case 0: pCargo(playerid, 0);
        case 1: pCargo(playerid, 1);
        case 2: pCargo(playerid, 2);
        case 3: pCargo(playerid, 3);
    }
    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SAWNOFF_SHOTGUN, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_MICRO_UZI, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, 999);
    SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, 999);
    if(pInfo[playerid][Estrelas] != 0){
        SetPlayerWantedLevel(playerid, pInfo[playerid][Estrelas]);
    }
    salvarConta(playerid);
    pInfo[playerid][trabalhando] = false;
    return 1;
}


public OnPlayerDeath(playerid, killerid, reason){
    SendDeathMessage(killerid, playerid, reason);
    SetPlayerInterior(playerid, 0);
    if(killerid != INVALID_PLAYER_ID && killerid != playerid && jobId[killerid] != 3 && GetPlayerWantedLevel(killerid) < 6){
        SetPlayerWantedLevel(killerid, GetPlayerWantedLevel(killerid) + 1);
    }
    if(killerid != INVALID_PLAYER_ID && jobId[killerid] == 3){
        SetPlayerInterior(playerid, 6);
        SetPlayerPos(playerid,263.4595, 76.8951, 1001.0391);
        prisaotimer2[playerid] = SetTimerEx("liberarPrisao", 665000, false, "i", playerid);
        SetPlayerWantedLevel(playerid, 0);
        ResetPlayerWeapons(playerid);
        SetPlayerScore(killerid, GetPlayerScore(killerid) + 1);
        PlayAudioStreamForPlayer(playerid, "http://191.254.239.88:7070/toouvindoalguemmechamar.mp3");
        pCargo(playerid, 2);
    }
    salvarConta(playerid);
    pInfo[playerid][trabalhando] = false;
    idChk[playerid] = 0;
    switch(jobId[playerid]){
        case 0: pCargo(playerid, 0);
        case 1: pCargo(playerid, 1);
        case 2: pCargo(playerid, 2);
        case 3: pCargo(playerid, 3);
    }
    DisablePlayerRaceCheckpoint(playerid);
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid){
    if(pickupid == bus){
        if (jobId[playerid] != 1){
            SendClientMessage(playerid, 0x8AB7C2FF, "Entre em um dos ônibus para começar a trabalhar!");
            pCargo(playerid, 1);
        }
        else{
            SendClientMessage(playerid, 0x8AB7C2FF, "Você saiu do emprego!");
            pCargo(playerid, 0);
            pInfo[playerid][trabalhando] = false;
            DisablePlayerRaceCheckpoint(playerid);
        }
    }
    else if(pickupid == policiaLS){
        if(GetPlayerWantedLevel(playerid) != 0){
            SendClientMessage(playerid, 0x8AB7C2FF, "Você está procurado(a), se entregue!");
            return 0;
        }
        if (jobId[playerid] != 2 && pInfo[playerid][trabalhando] == false){
            SendClientMessage(playerid, 0x8AB7C2FF, "Entre na Delegacia para pegar seu uniforme!");
            SendClientMessage(playerid, 0x8AB7C2FF, "/prender [ID] para prender um(a) meliante");
            pCargo(playerid, 3);
        } else{
            SendClientMessage(playerid, 0x8AB7C2FF, "Você não pode ser policial no momento!");
        }
    }
    else if(pickupid == uniformeMpolicia){
        if(jobId[playerid] == 3){
            SetPlayerSkin(playerid, 284);
            pInfo[playerid][trabalhando] = true;
        } else{
            SendClientMessage(playerid, 0x8AB7C2FF, "Acesso não autorizado.");
        }
    }
    else if(pickupid == uniformeFpolicia){
        if(jobId[playerid] == 3){
            SetPlayerSkin(playerid, 306);
            pInfo[playerid][trabalhando] = true;
        } else{
            SendClientMessage(playerid, 0x8AB7C2FF, "Acesso não autorizado.");
        }
    }
    else if(pickupid == armasPolicia){
        if(pInfo[playerid][trabalhando] == true && jobId[playerid] == 3){
            GivePlayerWeapon(playerid, 31, 120);
            GivePlayerWeapon(playerid, 32, 500);
            GivePlayerWeapon(playerid, 3, 1);
            SetPlayerArmour(playerid, 100.0);
            SendClientMessage(playerid, 0x8AB7C2FF, "Dica: digite /procurados e veja quem deve ir para o xilindró!");
        } else{
            SendClientMessage(playerid, 0x8AB7C2FF, "Uniforme é obrigatório.");
        }
    }

    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys){
    if(PRESSED( KEY_YES ) && pInfo[playerid][congelado] == true){
        CancelSelectTextDraw(playerid);
        pInfo[playerid][congelado] = false;
        new i;
        for(i=0; i<2; i++){
            PlayerTextDrawDestroy(playerid, conceLS[playerid][i]);
        }
        for(new i = 0; i < sizeof(lconceLS); i++){
            PlayerTextDrawDestroy(playerid, lconceLS[i][tdModel]);
            PlayerTextDrawDestroy(playerid, lconceLS[i][tdPreco]);
            PlayerTextDrawDestroy(playerid, lconceLS[i][tdName]);
        }
        return 1;
    }
    if (PRESSED( KEY_YES ) && IsPlayerInRangeOfPoint(playerid, 1.5, 605.7740,-1490.8625,14.9207) && pInfo[playerid][congelado] == false){
            listarVeiculos(playerid, 0);
            new i;
            for(i=0; i<3; i++){
                PlayerTextDrawShow(playerid, conceLS[playerid][i]);
            }
            SelectTextDraw(playerid, 0x00FF00FF);
            pInfo[playerid][congelado] = true;
    }
    if(PRESSED( KEY_YES ) && IsPlayerInRangeOfPoint(playerid, 1.5, 1858.5956,-1848.4109,13.5795)){
        if(jobId[playerid] != 0){
            pCargo(playerid, 0);
        }
        DisablePlayerRaceCheckpoint(playerid);
        pInfo[playerid][trabalhando] = false;
        SendClientMessage(playerid, 0x8AB7C2FF, "Escolha uma carga!");
        ShowPlayerDialog(playerid, falsidade, DIALOG_STYLE_TABLIST, "Cargas:",
        "Bebidas\t{33AA33}$12,000\n\
        Cigarros\t{33AA33}$10,000\n\
        Armas\t{33AA33}$20,000",
        "OK", "Cancelar");
    }
    return 1;
}

stock listarVeiculos(playerid, local){
    
    new Float:baseX = 155.0, Float:baseY = 116.0;
    new Float:spacingX = 105.0, Float:spacingY = 128.0;
    new index = 0;
    
    for(new i = 0; i < 2; i++){        // 2 linhas
        
        for(new j = 0; j < 3; j++) {          // 3 colunas
        
            if(index >= sizeof(lconceLS)) break;
            
            new Float:xPos = baseX + (j * spacingX);
            new Float:yPos = baseY + (i * spacingY);
            
            if(local == 0){
                // TextDraw do veículo
                lconceLS[index][tdModel] = CreatePlayerTextDraw(playerid, xPos, yPos, "aaaaa");
                PlayerTextDrawTextSize(playerid, lconceLS[index][tdModel], 94.000, 119.000);
                PlayerTextDrawAlignment(playerid, lconceLS[index][tdModel], 1);
                PlayerTextDrawColor(playerid, lconceLS[index][tdModel], -1);
                PlayerTextDrawSetShadow(playerid, lconceLS[index][tdModel], 0);
                PlayerTextDrawSetOutline(playerid, lconceLS[index][tdModel], 0);
                PlayerTextDrawBackgroundColor(playerid, lconceLS[index][tdModel], 28);
                PlayerTextDrawFont(playerid, lconceLS[index][tdModel], 5);
                PlayerTextDrawSetProportional(playerid, lconceLS[index][tdModel], 0);
                PlayerTextDrawSetPreviewModel(playerid, lconceLS[index][tdModel], lconceLS[index][vModel]);
                PlayerTextDrawSetPreviewRot(playerid, lconceLS[index][tdModel], -6.000, 0.000, 29.000, 0.799);
                PlayerTextDrawSetPreviewVehCol(playerid, lconceLS[index][tdModel], 211, 211);
                PlayerTextDrawSetSelectable(playerid, lconceLS[index][tdModel], 1);
                
                // TextDraw do preço
                new priceStr[32];
                format(priceStr, sizeof(priceStr), "$%d", lconceLS[index][vPreco]);
                lconceLS[index][tdPreco] = CreatePlayerTextDraw(playerid, xPos + 25.0, yPos + 4.0, priceStr);
                PlayerTextDrawLetterSize(playerid, lconceLS[index][tdPreco], 0.220, 1.299);
                PlayerTextDrawColor(playerid, lconceLS[index][tdPreco], 8388863);
                PlayerTextDrawSetShadow(playerid, lconceLS[index][tdPreco], 1);
                PlayerTextDrawSetOutline(playerid, lconceLS[index][tdPreco], 1);
                PlayerTextDrawBackgroundColor(playerid, lconceLS[index][tdPreco], 150);
                PlayerTextDrawFont(playerid, lconceLS[index][tdPreco], 1);
                PlayerTextDrawSetProportional(playerid, lconceLS[index][tdPreco], 1);
                
                // TextDraw do nome
                lconceLS[index][tdName] = CreatePlayerTextDraw(playerid, xPos + 10.0, yPos + 99.0, lconceLS[index][vName]);
                PlayerTextDrawLetterSize(playerid, lconceLS[index][tdName], 0.300, 1.500);
                PlayerTextDrawColor(playerid, lconceLS[index][tdName], -1);
                PlayerTextDrawSetShadow(playerid, lconceLS[index][tdName], 1);
                PlayerTextDrawSetOutline(playerid, lconceLS[index][tdName], 1);
                PlayerTextDrawBackgroundColor(playerid, lconceLS[index][tdName], 150);
                PlayerTextDrawFont(playerid, lconceLS[index][tdName], 1);
                PlayerTextDrawSetProportional(playerid, lconceLS[index][tdName], 1);
                
                PlayerTextDrawShow(playerid, lconceLS[index][tdModel]);
                PlayerTextDrawShow(playerid, lconceLS[index][tdPreco]);
                PlayerTextDrawShow(playerid, lconceLS[index][tdName]);
                
                index++;
            }
        }
    }
    conceLS[playerid][0] = CreatePlayerTextDraw(playerid, 465.000, 72.000, "X");
    PlayerTextDrawLetterSize(playerid, conceLS[playerid][0], 0.519, 2.599);
    PlayerTextDrawTextSize(playerid, conceLS[playerid][0], 482.000, 19.000);
    PlayerTextDrawAlignment(playerid, conceLS[playerid][0], 1);
    PlayerTextDrawColor(playerid, conceLS[playerid][0], -1);
    PlayerTextDrawSetShadow(playerid, conceLS[playerid][0], 1);
    PlayerTextDrawSetOutline(playerid, conceLS[playerid][0], 1);
    PlayerTextDrawBackgroundColor(playerid, conceLS[playerid][0], 150);
    PlayerTextDrawFont(playerid, conceLS[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, conceLS[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, conceLS[playerid][0], 1);

    conceLS[playerid][1] = CreatePlayerTextDraw(playerid, 239.000, 70.000, "Conce Los Santos");
    PlayerTextDrawLetterSize(playerid, conceLS[playerid][1], 0.509, 2.698);
    PlayerTextDrawAlignment(playerid, conceLS[playerid][1], 1);
    PlayerTextDrawColor(playerid, conceLS[playerid][1], 9145343);
    PlayerTextDrawSetShadow(playerid, conceLS[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, conceLS[playerid][1], 1);
    PlayerTextDrawBackgroundColor(playerid, conceLS[playerid][1], 255);
    PlayerTextDrawFont(playerid, conceLS[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, conceLS[playerid][1], 1);
}

stock ProcessarCompraVeiculo(playerid, vIndex){
    if(numPosse[playerid] >= 1){
        SendClientMessage(playerid, 0x8AB7C2FF, "Você não pode ter mais que dois veículos!");
        return 0;
    }
    
    if(GetPlayerMoney(playerid) < lconceLS[vIndex][vPreco]){
        SendClientMessage(playerid, 0x8AB7C2FF, "Você não tem dinheiro suficiente!");
        return 0;
    }

    if(GetPlayerWantedLevel(playerid) != 0){
        SendClientMessage(playerid, 0x8AB7C2FF, "Você está procurado(a), se entregue!");
        return 0;
    }
    
    GivePlayerMoney(playerid, -lconceLS[vIndex][vPreco]);

    compraVeiculo(playerid, lconceLS[vIndex][vModel], 603.4525, -1509.2405, 14.5352, 273.2852);

    new query[128];
    mysql_format(Conexao, query, sizeof(query), "SELECT * FROM veiculos WHERE pID = %d;", pInfo[playerid][ID]);
    mysql_tquery(Conexao, query, "vLoad", "d", playerid);

    new string[128];
    format(string, sizeof(string), "Compra realizada! Valor: %d", lconceLS[vIndex][vPreco]);
    SendClientMessage(playerid, 0xFF0000FF, string);
    CancelSelectTextDraw(playerid);
    for(new i = 0; i < 2; i++){
        PlayerTextDrawDestroy(playerid, conceLS[playerid][i]);
    }
    for(new i = 0; i < sizeof(lconceLS); i++){
        PlayerTextDrawDestroy(playerid, lconceLS[i][tdModel]);
        PlayerTextDrawDestroy(playerid, lconceLS[i][tdPreco]);
        PlayerTextDrawDestroy(playerid, lconceLS[i][tdName]);
    }
    return 1;
}


public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid){
    if(playertextid == conceLS[playerid][0]){ //x
        CancelSelectTextDraw(playerid);
        pInfo[playerid][congelado] = false;
        new i;
        for(i=0; i<2; i++){
            PlayerTextDrawDestroy(playerid, conceLS[playerid][i]);
        }
        for(new i = 0; i < sizeof(lconceLS); i++){
            PlayerTextDrawDestroy(playerid, lconceLS[i][tdModel]);
            PlayerTextDrawDestroy(playerid, lconceLS[i][tdPreco]);
            PlayerTextDrawDestroy(playerid, lconceLS[i][tdName]);
        }
        return 1;
    } else{
        for(new i = 0; i < sizeof(lconceLS); i++){
            if(playertextid == lconceLS[i][tdModel]){
                ProcessarCompraVeiculo(playerid, i);
                return 1;
            }
        }
    }
    return 0;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2){
    new string[48];
    format(string, sizeof(string), "ID das cores novas: %d, %d", color1, color2);
    SendClientMessage(playerid, 0x8AB7C2FF, string);
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate){
    if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER){
        new vehid = GetPlayerVehicleID(playerid);
        if(vehid == bus1 || vehid == bus2){
            if(jobId[playerid] != 1){
                SendClientMessage(playerid, 0x8AB7C2FF, "Você não é um(a) motorista de ônibus!");
                RemovePlayerFromVehicle(playerid);
                return 0;
            }
            if(GetPlayerWantedLevel(playerid) != 0){
                SendClientMessage(playerid, 0x8AB7C2FF, "Você está procurado(a), se entregue!");
                RemovePlayerFromVehicle(playerid);
                return 0;
            }
            else if(strcmp("motoronibus", pInfo[playerid][Cargo]) == 0 &&
             pInfo[playerid][trabalhando] == false && IsPlayerInRangeOfPoint(playerid, 20.0, -147.2776,1123.7859,19.8416)){
                idChk[playerid] = 1;
                SetPlayerRaceCheckpoint(playerid, 2, -126.3373,1149.3513,19.6916, 0, 0, 0, checkpsize);
                pInfo[playerid][trabalhando] = true;
            }
        }
        else if(vehid == copls1 || vehid == copls2 || vehid == copls3 || vehid == copls4 || vehid == copls5 || vehid == copls6 || vehid == copls7 || vehid == copls8
        || vehid == copls9 || vehid == copsf1 || vehid == copsf2 || vehid == copsf3 || vehid == copsf4 || vehid == coplv1 
        || vehid == coplv2 || vehid == coplv3 || vehid == coplv4 || vehid == coplv5){
            if(GetPlayerWantedLevel(playerid) != 0){
                SendClientMessage(playerid, 0x8AB7C2FF, "Você está procurado, se entregue!");
                RemovePlayerFromVehicle(playerid);
                return 0;
            } 
            if(jobId[playerid] != 3){
                SendClientMessage(playerid, 0x8AB7C2FF, "Você não é um(a) policial!");
                RemovePlayerFromVehicle(playerid);
                return 0;
            }
        }
        else if(vehid == isca){
            if(GetPlayerWantedLevel(playerid) == 0){
                SendClientMessage(playerid, 0x8AB7C2FF, "Que achado!");
            }
            if(jobId[playerid] != 3){
                SendClientMessage(playerid, 0x8AB7C2FF, "Você não é um(a) policial!");
                SetPlayerWantedLevel(playerid, 6);
                pInfo[playerid][Estrelas] = GetPlayerWantedLevel(playerid);
            }
        }
    }
    return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid){
    new vehid = GetPlayerVehicleID(playerid);
    switch(idChk[playerid]){
        case 1:{
            if(vehid == bus1 || vehid == bus2){
                DisablePlayerRaceCheckpoint(playerid);
                SetPlayerRaceCheckpoint(playerid, 2, -81.2518,1197.0790,19.6860, 0, 0, 0, checkpsize);
                idChk[playerid] = 2;
            } else{
                SendClientMessage(playerid, 0x8AB7C2FF, "Volte para seu veículo.");
            }
            return 1;
        }
        case 2:{
            if(vehid == bus1 || vehid == bus2){
                DisablePlayerRaceCheckpoint(playerid);
                SetPlayerRaceCheckpoint(playerid, 2, 318.0046,-1807.8722,4.5996, 0, 0, 0, checkpsize);
                SendClientMessage(playerid, 0x8AB7C2FF, "Leve os passageiros à praia com sua melhor rota!");
                idChk[playerid] = 3;
            } else{
                SendClientMessage(playerid, 0x8AB7C2FF, "Volte para seu veículo.");
            }
            return 1;
        }
        case 3:{
            if(vehid == bus1 || vehid == bus2){
                DisablePlayerRaceCheckpoint(playerid);
                new string[200];
                format(string, sizeof(string), "Rota concluída! Pagamento: $%d", 2000+(random(1000)+1));
                SendClientMessage(playerid, 0x8AB7C2FF, string);
                SendClientMessage(playerid, 0x8AB7C2FF, "Volte para sua sede se quiser trabalhar novamente!");
                GivePlayerMoney(playerid, 2000+(random(1000)+1));
                SetPlayerScore(playerid, GetPlayerScore(playerid)+1);
                pInfo[playerid][trabalhando] = false;
            } else{
                SendClientMessage(playerid, 0x8AB7C2FF, "Volte para seu veículo.");
            }
            return 1;
        }
        case 4:{
            if(vehid == crimetruck[playerid]){
                DisablePlayerRaceCheckpoint(playerid);
                SendClientMessage(playerid, 0x8AB7C2FF, "Esquema concluído!");
                idChk[playerid] = 0;
                GivePlayerMoney(playerid, 12000);
                SetPlayerScore(playerid, GetPlayerScore(playerid)+1);
                pInfo[playerid][trabalhando] = false;
                DestroyVehicle(vehid);
            } else{
                SendClientMessage(playerid, 0x8AB7C2FF, "Volte para seu veículo.");
            }
            return 1;
        }
        case 5:{
            if(vehid == crimetruck[playerid]){
                DisablePlayerRaceCheckpoint(playerid);
                SendClientMessage(playerid, 0x8AB7C2FF, "Esquema concluído!");
                idChk[playerid] = 0;
                GivePlayerMoney(playerid, 10000);
                SetPlayerScore(playerid, GetPlayerScore(playerid)+1);
                pInfo[playerid][trabalhando] = false;
                DestroyVehicle(vehid);
            } else{
                SendClientMessage(playerid, 0x8AB7C2FF, "Volte para seu veículo.");
            }
            return 1;
        }
        case 6:{
            if(vehid == crimetruck[playerid]){
                DisablePlayerRaceCheckpoint(playerid);
                SendClientMessage(playerid, 0x8AB7C2FF, "Esquema concluído!");
                idChk[playerid] = 0;
                GivePlayerMoney(playerid, 20000);
                SetPlayerScore(playerid, GetPlayerScore(playerid)+1);
                pInfo[playerid][trabalhando] = false;
                DestroyVehicle(vehid);
            } else{
                SendClientMessage(playerid, 0x8AB7C2FF, "Volte para seu veículo.");
            }
            return 1;
        }
    }
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success){
    if (!success)
    {
       SendClientMessage(playerid, 0x29D8FFFF,"Comando inválido!");
    }
    return 1;
} 

public OnPlayerDisconnect(playerid, reason){
    if(pInfo[playerid][logado] == true){
        salvarConta(playerid);
        DestroyVehicle(veiculo1[playerid]);
        DestroyVehicle(veiculo2[playerid]);
        liberarDados(playerid);
    }
    return 1;
}

CMD:modofuga(playerid,params[]){
    if(GetPlayerMoney(playerid) >= 25000){
        SetPlayerColor(playerid, 0xFF000000);
        GivePlayerMoney(playerid, -25000);
        new string[128];
        format(string, sizeof(string), "%s ativou o modo fuga por 50 segundos!", pName(playerid));
        SendClientMessageToAll(0xFF0000FF, string);
        SetTimerEx("perdeuFuga", 50000, false, "i", playerid);
    } else{
        SendClientMessage(playerid, 0x29D8FF,"Dinheiro insuficiente, arranje mais!");
    }
    return 1;
}

forward perdeuFuga(playerid);
public perdeuFuga(playerid){
    switch(jobId[playerid]){
        case 0: pCargo(playerid, 0);
        case 1: pCargo(playerid, 1);
        case 2: pCargo(playerid, 2);
        case 3: pCargo(playerid, 3);
    }
    SendClientMessage(playerid, 0x29D8FF, "Você está visível novamente.");
    return 1;
}

CMD:modofugaoff(playerid,params[]){
    switch(jobId[playerid]){
        case 0: pCargo(playerid, 0);
        case 1: pCargo(playerid, 1);
        case 2: pCargo(playerid, 2);
        case 3: pCargo(playerid, 3);
    }
    new string[128];
    format(string, sizeof(string), "%s desativou o modo fuga!", pName(playerid));
    SendClientMessageToAll(0x00FF00FF, string);
    return 1;
}

CMD:venderveiculo(playerid,params[]){
    if(IsPlayerInRangeOfPoint(playerid, 20.0, -2022.2340,-100.0629,35.1641)){
        new vid = GetPlayerVehicleID(playerid);
        new query[150];
        new query3[100];
        if(vid == veiculo1[playerid]){
            mysql_format(Conexao, query, sizeof(query), "delete from veiculos where numPosse = 0 and pID = %d;",
            pInfo[playerid][ID]);
            mysql_tquery(Conexao, query);
            new query2[150];
            mysql_format(Conexao, query2, sizeof(query2), "update veiculos set numPosse = 0 where pID = %d and numPosse = 1;",
            pInfo[playerid][ID]);
            mysql_tquery(Conexao, query2);
            DestroyVehicle(vid);
            SendClientMessage(playerid, 0x8AB7C2FF, "Veículo 1 vendido!");
        }
        else if(vid == veiculo2[playerid]){
            mysql_format(Conexao, query, sizeof(query), "delete * from veiculos where numPosse = 1 and pID = %d;",
            pInfo[playerid][ID]);
            mysql_tquery(Conexao, query);
            DestroyVehicle(vid);
            SendClientMessage(playerid, 0x8AB7C2FF, "Veículo 2 vendido!");
        } else{
            SendClientMessage(playerid, 0x8AB7C2FF, "Você deve estar em um de seus veículos para poder realizar a venda!");
            return 1;
        }
        mysql_format(Conexao, query3, sizeof(query3), "select * from veiculos where pID = %d;", pInfo[playerid][ID]);
        mysql_tquery(Conexao, query3, "vLoad", "d", playerid);
    }
    return 1;
}

CMD:salvarvpos(playerid,params[]){
    if(GetPlayerWantedLevel(playerid) != 0){
        SendClientMessage(playerid, 0x8AB7C2FF, "Você está procurado(a), se entregue!");
        return 0;
    }
    new checkveiculo = GetPlayerVehicleID(playerid);
    new posse = -1;
    new Float:vX, Float:vY, Float:vZ, Float:vROT;
    new cor1, cor2;
    GetVehiclePos(checkveiculo, vX, vY, vZ);
    GetVehicleZAngle(checkveiculo, vROT);
    GetVehicleColor(checkveiculo, cor1, cor2);
    new vID = GetVehicleModel(checkveiculo);
    if(checkveiculo == veiculo1[playerid]){
        posse = 0;
    }
    else if(checkveiculo == veiculo2[playerid]){
        posse = 1;
    }
    
    if(posse == -1){
        SendClientMessage(playerid, 0x8AB7C2FF, "Você deve estar em um de seus veículos para salvar a posição!");
        return 1;
    }
    
    salvarVeiculo(playerid, checkveiculo, posse);

    if(posse == 0){
        DestroyVehicle(veiculo1[playerid]);
        veiculo1[playerid] = CreateVehicle(vID, vX,vY,vZ,vROT, cor1, cor2, -1);
        PutPlayerInVehicle(playerid, veiculo1[playerid], 0);
    }
    else if(posse == 1){
        DestroyVehicle(veiculo2[playerid]);
        veiculo2[playerid] = CreateVehicle(vID, vX,vY,vZ,vROT, cor1, cor2, -1);
        PutPlayerInVehicle(playerid, veiculo2[playerid], 0);
    }

    new msg[64];
    format(msg, sizeof(msg), "Posição e cor do veículo %d salvas com sucesso!", posse);
    SendClientMessage(playerid, 0x8AB7C2FF, msg);
    return 1;
}

CMD:lista(playerid,params[]){
    new str[681+1];

    format(str, sizeof(str), "{9982FF}/lista {ED6C11}(mostra a lista de comandos) {9982FF} /modofuga /modofugaoff /corv [cor1] [cor2]\n \
    /dizer /blindar {FF4D97}/salvarvpos{9982FF} {ED6C11}(salva onde o veículo está e a cor dele){9982FF} /radios /alterarplaca\n \
    {9982FF}/stopr {ED6C11}(para de reproduzir a rádio/stream) {FF4D97}/celular{9982FF} /skin /meusdados", str);
    ShowPlayerDialog(playerid, LISTA, DIALOG_STYLE_MSGBOX, "{29D8FF}Comandos:", str, "Aceitar", "");
    return 1;
}

CMD:ajuda(playerid,params[]){
    new str[681+1];

    format(str, sizeof(str), "{9982FF}Este é a gamemode S70! O que ela oferece:\n Cargos de motorista de ônibus, policial, criminoso;\n \
    Esconda seu ícone no radar para despistar ou surpreender alguém (/modofuga /modofugaoff)\nTodas as skins do jogo à vontade (/skins)\n \
    E muito mais! Digite{ED6C11} /lista \
    {9982FF}para mostrar a lista completa de comandos!", str);
    ShowPlayerDialog(playerid, LISTA, DIALOG_STYLE_MSGBOX, "{29D8FF}Comandos:", str, "Aceitar", "");
    //SetPlayerPos(playerid, -2022.2340,-100.0629,35.1641); // debug
    PlayAudioStreamForPlayer(playerid, "http://191.254.239.88:7070/toouvindoalguemmechamar.mp3");
    return 1;
}

CMD:radios(playerid,params[]){
    SendClientMessage(playerid, 0x4D00C1FF, "/jpsp");
    SendClientMessage(playerid, 0x4D00C1FF, "/transfmrio");
    SendClientMessage(playerid, 0x4D00C1FF, "/novabrasil");
    SendClientMessage(playerid, 0x4D00C1FF, "/mixfm");
    SendClientMessage(playerid, 0x4D00C1FF, "/antena1");
    return 1;
}

CMD:skin(playerid,params[]){
    if(GetPlayerWantedLevel(playerid) != 0){
        SendClientMessage(playerid, 0x8AB7C2FF, "Você está procurado(a), se entregue!");
        return 0;
    }
    ShowPlayerDialog(playerid, escSKIN, DIALOG_STYLE_INPUT, "Escolha sua skin", "Digite o id da skin que quer utilizar!\n \
    Caso não saiba, procure no google 'samp skin ids'", "Aplicar", "Sair");
    SendClientMessage(playerid, 0x8AB7C2FF, "Sua skin mudará no próximo spawn.");
    return 1;
}

CMD:meusdados(playerid,params[]){
    new string[500];
    pInfo[playerid][Estrelas] = GetPlayerWantedLevel(playerid);
    format(string, sizeof(string), "Nome: %s  Nível: %d  ID da skin: %d\n\
    Dinheiro: $%d Cargo: %s", pName(playerid), pInfo[playerid][Nivel],
    pInfo[playerid][Skin], pInfo[playerid][Grana], pInfo[playerid][Cargo]);
    ShowPlayerDialog(playerid, dados, DIALOG_STYLE_MSGBOX, "Suas informações no banco de dados:", string, "OK", "");
    return 1;
}

CMD:procurados(playerid,params[]){
    if(jobId[playerid] == 3 && pInfo[playerid][trabalhando] == true){
        new string[500];
        new count = 0;
        format(string, sizeof(string), "");
        foreach(new i: Player){
            if(GetPlayerWantedLevel(i) > 0){
                new temp[50];
                format(temp, sizeof(temp), "%s - %d *\n", pName(i), GetPlayerWantedLevel(i));
                strcat(string, temp);
                count++;
            }
        }
        if(count == 0){
            format(string, sizeof(string), "Não há foras da lei!");
        }
        ShowPlayerDialog(playerid, procurados, DIALOG_STYLE_MSGBOX, "Lista de procurados", string, "OK", "");
    } else{
        SendClientMessage(playerid, 0x8AB7C2FF, "Você não é um policial uniformizado!");
    }
    return 1;
}

CMD:prender(playerid,params[]){  //TESTAR COM MAIS DE UM PLAYER JOGANDO
    if(jobId[playerid] != 3) return 1;
    new alvoid;
    new Float:alvox, Float:alvoy, Float:alvoz;
    GetPlayerPos(alvoid, alvox, alvoy, alvoz);
    if(sscanf(params, "u", alvoid)){
        return SendClientMessage(playerid, 0x8AB7C2FF, "Use: /prender [ID]");
    } 
    else if(!IsPlayerConnected(alvoid)) return SendClientMessage(playerid, 0xFF0000AA, "ID inválido!"); 
    else if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, 0xFF0000AA, "A prisão é feita fora de um veículo!");
    else{
        if(!IsPlayerInRangeOfPoint(playerid, 2.0, alvox,alvoy,alvoz)) return SendClientMessage(playerid, 0xFF0000AA, "Você está longe do alvo!");
        else{
            if(alvoid == playerid) return SendClientMessage(playerid, 0xFF0000AA, "Você não pode se prender!"); 
            else if(jobId[alvoid] != 2){
                new string[50];
                format(string, sizeof(string), "%s foi preso(a)!", pName(alvoid));
                SetPlayerInterior(alvoid, 6);
                SetPlayerPos(alvoid,263.4595, 76.8951, 1001.0391);
                prisaotimer3[alvoid] = SetTimerEx("liberarPrisao", 665000, false, "i", alvoid);
                SetPlayerWantedLevel(alvoid, 0);
                ResetPlayerWeapons(alvoid);
                pInfo[alvoid][trabalhando] = false;
                PlayAudioStreamForPlayer(alvoid, "http://191.254.239.88:7070/toouvindoalguemmechamar.mp3");
                pCargo(alvoid, 2);
                SendClientMessageToAll(0xFF0000AA, string);
                SetPlayerScore(playerid, GetPlayerScore(playerid) + 1);
                GivePlayerMoney(playerid, 5000);
                SendClientMessage(playerid, 0xFF0000AA, "Use /liberar [ID] caso queira encerrar a pena!");
            } else return SendClientMessage(playerid, 0xFF0000AA, "Este id já está preso!");
        }
    }
    return 1;
}

CMD:liberar(playerid,params[]){  //TESTAR COM MAIS DE UM PLAYER JOGANDO
    if(jobId[playerid] != 3) return 1;
    new alvoid;
    new Float:alvox, Float:alvoy, Float:alvoz;
    GetPlayerPos(alvoid, alvox, alvoy, alvoz);
    if(sscanf(params, "u", alvoid)){
        return SendClientMessage(playerid, 0x8AB7C2FF, "Use: /liberar [ID]");
    }
    if(GetPlayerInterior(playerid) != 6) return SendClientMessage(playerid, 0xFF0000AA, "Você não está na delegacia!");
        else{
            if(alvoid == playerid) return SendClientMessage(playerid, 0xFF0000AA, "Você não pode se liberar!"); 
            else if(jobId[alvoid] == 2){
                new string[50];
                format(string, sizeof(string), "%s foi solto(a)!", pName(alvoid));
                SetPlayerWantedLevel(alvoid, 0);
                liberarPrisao(alvoid);
                SendClientMessageToAll(0xFF0000AA, string);
            } else return SendClientMessage(playerid, 0xFF0000AA, "Este id já está livre!");
        }
    return 1;
}

forward liberarPrisao(playerid);
public liberarPrisao(playerid){
    pCargo(playerid, 0);
    SetPlayerInterior(playerid, 0);
    KillTimer(prisaotimer[playerid]);
    KillTimer(prisaotimer2[playerid]);
    KillTimer(prisaotimer3[playerid]);
    StopAudioStreamForPlayer(playerid);
    SetPlayerPos(playerid,1599.1313, -1636.3346, 13.7188);
    SendClientMessage(playerid, 0x29D8FF, "Você está livre, não cometa mais crimes!");
    return 1;
}

CMD:corv(playerid,params[]){
    if(jobId[playerid] == 2) return 1;
    new cmdcor1, cmdcor2;
    if(sscanf(params, "ii", cmdcor1, cmdcor2)){
        return SendClientMessage(playerid, 0x8AB7C2FF, "Use: /corv [cor1] [cor2], caso não souber, pesquise 'samp vehicle color ids'!");
    }
    ChangeVehicleColor(GetPlayerVehicleID(playerid), cmdcor1, cmdcor2);
    return 1;
}