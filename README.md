# ![](http://i.imgur.com/10dpAqU.png) DevChat

This app allows users to take photos or record videos with the front or rear facing cameras, they can also select if they want to use flash or not. After taking the shot, they can share it with their friends and watch received media on a list.   
User accounts are created and validated through [FirebaseAuth](https://firebase.google.com/docs/auth/) using the email and password method. The [FirebaseDatabase](https://firebase.google.com/docs/database/) is used to store user profile and message request information, while [FirebaseStorage](https://firebase.google.com/docs/storage/) is used to store the video and photo files. The camera view was easily implemented by using [SwiftyCam](https://github.com/Awalz/SwiftyCam).  
