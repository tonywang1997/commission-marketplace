# Commission Marketplace

## Product

* Link to website: [https://fierce-taiga-25712.herokuapp.com/](https://fierce-taiga-25712.herokuapp.com/)

### Purpose

The Commission Marketplace is a platform where:

* Artists have a platform to advertise and offer services to potential clients
* Clients can come to find and request artists to make commissioned art for them.

### Page breakdown

* Homepage: View, search, and sort images that have been uploaded by artists. If you find an image with a style you enjoy, hover over it and click "Find similar images" to display images with similar styles.
* Dashboard: Edit your profile picture and bio, check your message inbox, and add portfolios to display your artwork.
* Storefront: Display your artwork and message other users.
* Bounty Board: Post your project ideas to find or commission collaborators, or view other people's ideas to find projects to participate in.


## Versions

* Ruby 2.6.5p114
* Rails 6.0.3
* PostgreSQL 12.1
* Redis server 6.0.1

## How to run locally

1. Clone the GitHub repository with `git clone https://github.com/eberleant/commission-marketplace`
2. `cd` into the `commission-marketplace` folder
3. Run `bundle install`
4. Run `yarn install --check-files`
5. If necessary, install Redis using your package manager (eg, `brew install redis`)
6. Start your Redis server with `redis-server`
7. To seed the database, run `rails db:seed`
8. Start your Rails server with `rails server` 
9. Access the website at `http://localhost:3000/`

