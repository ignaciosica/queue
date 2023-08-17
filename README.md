# Queue 
### Collaborative Priority Queue for Spotify

Welcome to Queue! This app allows multiple users to queue up and play songs from their own Spotify accounts, in a priority queue ordered by votes.

<div align="center">

| <img src="https://user-images.githubusercontent.com/95779146/209579660-920eb4bd-9a14-4f89-995a-ae3831d262fe.jpg" width="300" /> | <img src="https://github.com/p4sscode/queue/assets/95779146/820a33ae-f6ec-4f24-812c-614d9625778c" width="300"/> | <img src="https://github.com/p4sscode/queue/assets/95779146/2b45ad04-e2ae-4428-89e5-8b97f8cf5336" width="300"/> |
| :---: | :---: | :---: |
| Figma mockup | Flutter release app (Room Screen) | Flutter release app (Search Screen) |
</div>

## Features

- Join and create rooms 
- Vote, add and remove songs from the queue
- Search for songs, artists and albums
- Play queue on Spotify
- Play, pause and vote for Skip
- See the currently playing song and the upcoming track

## Tech Stack

- [Flutter](https://flutter.dev): A cross-platform mobile app development framework
- [Firebase](https://firebase.google.com): A suite of tools for building mobile and web applications
- [Spotify Web Api](https://developer.spotify.com/documentation/web-api): Enables the creation of applications that can interact with Spotify's streaming service, such as retrieving content metadata, getting recommendations, creating and managing playlists, or controlling playback.

## Architecture
<div align="center">

<img src="https://github.com/p4sscode/queue/assets/95779146/1065a560-c181-4116-8797-8eda1eee7029" width="500"/>
</div>

## Challenges

Buildng this project I came across three significant challenges that I'd like to address.

1. Flutter Background Task Limitations:
One major hurdle was the immature and buggy state of Flutter background tasks. Specifically, while using Workmanager – the official package for managing background tasks – I found it lacking in crucial features. Notably, there was no straightforward way to access the task's current state or its resulting output. This absence of information made it difficult to ensure the proper functioning of the app's features.

2. Battery Optimization Impact:
In the current landscape of smartphones, battery optimization is a prevalent concern. Modern phones tend to optimize battery usage aggressively, which can inadvertently lead to background tasks being prematurely suspended and later resumed. Consequently, this behavior negatively affected the reliability of the app's functionality. This was particularly problematic because the background task is responsible for monitoring changes in the queue and player state, and subsequently taking appropriate actions.

3. Lack of Official Spotify SDK for Flutter:
The absence of an official Spotify SDK for Flutter emerged as a significant obstacle, compelling me to delve into community solutions and innovative workarounds. While certain features were addressed through minimal.me's Spotify SDK, I had to turn to the Spotify Web API for pending functionalities.

While working on the project, these challenges presented notable obstacles. Finding solutions or workarounds for these limitations became imperative to ensure the app's performance and reliability. The lack of access to task state and result, coupled with battery optimization concerns, prompted me to explore alternative approaches to address these issues effectively.

Please note that addressing these challenges might involve diving into the latest developments within Flutter's ecosystem or looking for third-party packages that provide better background task management. Additionally, testing on a range of devices and scenarios to evaluate the app's behavior under various conditions could be beneficial in enhancing its overall performance.

## Alternative
To deal with the underwhelming performance of the background task and the limitations of the third-party Spotify SDK, I came up with a different plan. Instead of sticking to on-device background tasks to watch over the queue and player status, I decided to take things to the cloud. I set up cloud functions that kick in whenever there's a change in player state or the queue. When a user wants to press play, they hook up with Spotify, and their authorization token gets sent over to the functions. These functions then step in and use Spotify's web API to handle the playing. 

Unfortunately, the lack of hooks for Spotify's player state leaves no other option apart from periodic calls, making this alternative extremely expensive as the frecuency required is rather high. Based on rough calculations, Firestore free-tier could only support 40 rooms playing all month long.

If sometime in the future spotify makes hooks available, this new approach may turn out to be way more reliable and smooth, keeping the music flowing seamlessly. 

![image](https://github.com/p4sscode/queue/assets/95779146/8bb39252-5898-46fc-9e8a-212964f71c41)

## Final thoughts

Taking on the challenge of building this app was fueled by the excitement of exploring a concept that was missing from Spotify's native features. I saw the potential for something big here, especially for parties and events. Imagine a scenario where everyone gets to have a say in the music – it's like a DJ-ing democracy! People can suggest songs, and everyone else can vote for their favorites. The DJ then takes these votes as cues for what to play.

But why stop there? This concept could be a game-changer in other places too, like at the gym. Picture this: a shared playlist where anyone can add their jam, making those workout sessions way more fun. It's all about music that everyone vibes with.

So, the bottom line is, I saw a gap in how music was being shared and enjoyed, and I wanted to fill it with something interactive and communal. The potential to create a platform that caters to both personal and group preferences is what got me excited about diving into this project!

## Contribute

We welcome contributions! If you have an idea for a new feature or have found a bug, please don't hestitate opening an issue or submiting a pull request.

## License

The Collaborative Priority Queue for Spotify is licensed under the [MIT License](https://opensource.org/license/mit/).
