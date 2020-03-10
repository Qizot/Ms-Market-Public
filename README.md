# MS-Market
**DISCLAIMER** 
<br>this repo has no history as I had to remove all secret tokens which unforunately got into revision system :(

## Introduction

Mobile app and backend environment to be used as a borrow/lend platfrom for students accomodated at AGH Student Town.
The main goal is for students to login in via Oauth2 API provided by DSNET (student town's internet and accomodation system provider), register new items and search for other items when in need. System gets to know studen's current dormitory which makes it easy to search for an item in a particular dormitory.
## Technologies used:
### Frontend
- Flutter (multi platform framework for developing mobile apps)

### Backend
- Elixir language
- Phoenix framework
- GraphQL Absitnhe library
- Ecto library with Postgres database
- Postgres full-text search
- Go language for images server

#### Challanges I encountered during development
It was my second attempt to create application in flutter and this time it was way more demanding.
First thing that caused me troubles was integrating oauth authentication, there were many solutions but a lot of them
were poorly documented. I ended up using flutter_web_auth package that played well.

After that was the time was up to set up state manegement. I went for bloc pattern which worked great with
implementing all graphql logic and event passing. Reactive programming happened to be great for mobile development.

I struggled a lot to come up with any sensible ui/ux but I learned a lot.

Backend development had its traps as well. First of all n+1 queries problem which I solved with dataloader library which works as expected, quering single object from database only once, but I failed to apply it to aggregations though.
Trying full-text search for the first time was quite challenging, not only the concept of designing search schema in database but maintenance as well. I ended up creating materialized view and some triggers responsible for refreshing the view. I noticed that the refreshing can be a bottleneck while inserting new item's data when there is over 5k items already. My plan is to create backend service to refresh the view periodically with some debounce treshold. 

#### Yet to do
Main thing is to prepare for backend deployment, mainly to create docker setup and produciton configs. I've got a msmarket domain till June 2020 so it might be useful for obtaining ssl certificates from let's encrypt project. If I fail to deploy it anywhere the project still was a great opportunity to learn mobile development with some backend tweaks. I would love to do it again but this time with some real time communication via phoenix channels or graphql subscriptions. 




