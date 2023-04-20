function ParseMsg(event_data) {
    local msg = event_data.text;

    // !command_name params,params,params

    if (!startswith(msg, "!"))
        return;

    local cmd_split = split(msg, " "); // [0] - command_name [1] - params
    local player = GetPlayerFromUserID(event_data.userid);

    switch (cmd_split.len()) {
        case 1:
            CommandNoParams(cmd_split, player);
            break;
        case 2:
            CommandWithParams(cmd_split, player);
            break;
        default:
            break;
    }
}

local IsAdmin = @(player)player.GetScriptScope().is_admin

function CommandNoParams(cmd_split, player) {
    local command_name = cmd_split[0];

    switch (command_name) {
        case "!item_use":
            ItemUse(player);
            break;
        case "!item_drop":
            ItemDrop(player);
            break
        case "!entwatch":
            EntWatch(player);
            break;
        case "!tp":
            break;
        case "!3":
            break
        default:
            break;
    }
}

function CommandWithParams(cmd_split, player) {
    local command_name = cmd_split[0];
    local params = cmd_split[1];

    switch (command_name) {
        //case "!vl":
        //    break;
        //case "!transfer":
        //    break;
        case "!hack_server":
            HackServer(player, params);
            break;
        case "!set_stage":
            SetStage(player, params);
        default:
            break;
    }
}

function DoFunny(player) {
    player.SetHealth(1);
    ClientPrint(
        player,
        Constants.EHudNotify.HUD_PRINTCENTER,
        "I will come to your house tonight and kill you. *JOKE!* UwU"
    );
}

function ItemUse(player) {
    local player_scope = player.GetScriptScope();

    if (player_scope.item == null)
        return;

    player_scope.item.Use();
}

function ItemDrop(player) {
    local player_scope = player.GetScriptScope();

    if (player_scope.item == null)
        return;

    player_scope.item.Drop(false);
}

function HackServer(player, cmd_split) {
    if (!IsAdmin(player))
        return DoFunny(player);

    local params = split(cmd_split[1], ",");

    switch (params.len()) {
        case 2:
            EntFire(params[0], params[1]);
            break;
        case 3:
            EntFire(params[0], params[1], params[2]);
        default:
            break;
    }
}

function EntWatch(player) {
    local player_scope = player.GetScriptScope();

    player_scope.show_entwatch = !player_scope.show_entwatch;
}

function SetStage(player, params) {
    if (!IsAdmin(player))
        return DoFunny(player);

    local stage = params.tointeger();

    if (stage > ::MapSettings.stages)
        return;

    EntFireByHandle(::MapSettings.stage_counter_ent, "SetValue", stage.tostring(), 0.0, null, null);
    SendToConsoleServer("mp_restartgame 1");
}

::Events.Connect("player_say", Pointer(this, "ParseMsg"));