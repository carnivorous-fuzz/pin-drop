# *Location Messaging*

iOS location-based media sharing app. Users are able to login to the app, and see messages left by others in an area around them. They can also upload messages of their own.

## User Stories

**Required** functionality:

- [ ] Login
   - [ ] Authenticate user using OAuth (Google, FB, or Twitter).
- [ ] Home page
   - [ ] User should see a list of all pending/unviewed messages on home screen, sorted by distance from current location.
   - [ ] User should be able to toggle between map view and list view for pending messages.
- [ ] Create location message
   - [ ] User can create a pin message, which consists of a location, tagline, and some media content (pictures first).
   - [ ] Newly created messages are posted to the public "home" feed.
- [ ] Retrieve location message
   - [ ] When user is within range of a pin message, the message becomes "available" to view.
   - [ ] After viewing a message, the message is marked as "viewed" and put into an archive.

**Optional** features:

- [ ] Login
   - [ ] Sign up with user name and password
- [ ] Home page
   - [ ] Private feed and public feed.
   - [ ] User can toggle to sort by distance, time message was created, highest rated, etc.
- [ ] Create message
   - [ ] Enable video content for messaging.
   - [ ] User can create private message groups (1+ other users).
   - [ ] User can send direct messages to specific users or groups.
   - [ ] User can specify time after which message should delete automatically.
   - [ ] User can post multiple messages as a sequence or group posting. All messages must be "retrieved" by another user for the posting to be marked as viewed (i.e. start to create a concept of "tours").
   - [ ] Users can remove their own messages
- [ ] Retrieve message
   - [ ] Users can comment on and like messages.
   - [ ] Users can access an archive of "viewed" messages.
- [ ] Gamification
   - [ ] Users collect points for finding pin messages or creating content.
- [ ] Business interaction
   - [ ] Businesses can create a group, and invite people. Give out promotions, only users who visits the business location can view the promotion.

[Google Doc](https://docs.google.com/spreadsheets/d/1Gt9Vq7hf5kCIKTsnLPe2V9hwP1ld5uV749G3nETrglo/edit?usp=sharing)

## Wireframes

[Wireframe](https://carnivorous-fuzz.mybalsamiq.com/projects/draft/New%20Mockup%201)
<img src="https://i.imgur.com/1cTpdOT.png" alt="wireframe">

## License

    Copyright [2017] [Raina Wang, Wuming Xie, and Paul Sokolik]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
