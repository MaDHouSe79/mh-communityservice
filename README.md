<p align="center">
    <img width="140" src="https://icons.iconarchive.com/icons/iconarchive/red-orb-alphabet/128/Letter-M-icon.png" />  
    <h1 align="center">Hi 👋, I'm MaDHouSe</h1>
    <h3 align="center">A passionate allround developer </h3>    
</p>

<p align="center">
  <a href="https://github.com/MaDHouSe79/mh-communityservice/issues">
    <img src="https://img.shields.io/github/issues/MaDHouSe79/mh-communityservice"/> 
  </a>
  <a href="https://github.com/MaDHouSe79/mh-communityservice/network/members">
    <img src="https://img.shields.io/github/forks/MaDHouSe79/mh-communityservice"/> 
  </a>  
  <a href="https://github.com/MaDHouSe79/mh-communityservice/stargazers">
    <img src="https://img.shields.io/github/stars/MaDHouSe79/mh-communityservice?color=white"/> 
  </a>
  <a href="https://github.com/MaDHouSe79/mh-communityservice/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/MaDHouSe79/mh-communityservice?color=black"/> 
  </a>      
</p>

<p align="center">
  <img alig src="https://github-profile-trophy.vercel.app/?username=MaDHouSe79&margin-w=15&column=6" />
</p>

<p align="center">
  <img alig src="https://raw.githubusercontent.com/kamranahmedse/driver.js/master/demo/images/split.png" />
</p>

## MH-CommunityService, to punish players
- Punish misbehaved players.
- players must complete their community service before they can continue playing.
- Rejoining the server is not going to work to get out of community service.
- Run away will not work, you will get punish ever time when you walk away from the location.
- If a player gets in community service, all the players on the server will know it.

## 💪 Dependencies
- ✅ [oxmysql](https://github.com/overextended/oxmysql/releases/tag/v1.9.3)
- ✅ [qb-core](https://github.com/qbcore-framework/qb-core)

## Install
- place the folder `mh-communityservice` in `resources/[qb]`
- add the sql table to your database.
- restart your server

## How to apply community service.
- Use the /comserv [player_id] [service_count] command (only admins).
- Use the /endcomserv [player_id] to finish a player's community service (only admins).


## For qb-radialmenu police job actions.(F1 Job Menu)
```lua
{
    id = 'comserv',
    title = 'Comm Service',
    icon = 'user-lock',
    type = 'client',
    event = 'mh-communityservice:client:opencomserv',
    shouldClose = true
}
```

## 🐞 Any bugs issues or suggestions, let my know.

## 🙈 Youtube & Discord
- [Youtube](https://www.youtube.com/channel/UC6431XeIqHjswry5OYtim0A)
- [Discord](https://discord.gg/cEMSeE9dgS)
