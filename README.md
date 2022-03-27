## qb-communityservice, to punish players
- Punish misbehaved players.
- players must complete their community service before they can continue playing.
- Rejoining the server is not going to work to get out of community service.
- Run away will not work, you will get punish ever time when you walk away from the location.
- If a player gets in community service, all the players on the server will know it.

## 💪 Dependencies
- ✅ [oxmysql](https://github.com/overextended/oxmysql/releases/tag/v1.9.3)
- ✅ [qb-core](https://github.com/qbcore-framework/qb-core)

## Install
- place the folder `qb-communityservice` in `resources/[qb]`
- add the sql table to your database.
- restart your server

## How to apply community service.
- Use the /comserv [player_id] [service_count] command (only admins).
- Use the /endcomserv [player_id] to finish a player's community service (only admins).


## Or for qb-radialmenu police job actions.
```lua
{
    id = 'comserv',
    title = 'Comm Service',
    icon = 'user-lock',
    type = 'client',
    event = 'qb-communityservice:client:opencomserv',
    shouldClose = true
}
```

## Trigger you can use for the police
- You can use if you want a trigger in your police server 
```lua
TriggerEvent('qb-communityservice:sendToCommunityService', id, amount)
```
- or a client trigger in police client
```lua
TriggerServerEvent('qb-communityservice:sendToCommunityService', id, amount)
```

## 🐞 Any bugs issues or suggestions, let my know.

## 🙈 Youtube & Discord
- [Youtube](https://www.youtube.com/channel/UC6431XeIqHjswry5OYtim0A)
- [Discord](https://discord.gg/cEMSeE9dgS)
