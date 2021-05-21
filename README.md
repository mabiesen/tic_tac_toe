# tic_tac_toe
tic tac toe, made from scratch

## REQUIREMENTS

Must have the following gem installed

https://github.com/tj/terminal-table

TODO: make gemfile

## HOW TO PLAY

#### BASIC

1. clone down this repository
2. bundle install
3. run "ruby ./tic_tac_toe.rb" while in the repo's root directory

TODO: make file references dynamic such that users are not required to be in the root repo directory

#### DOCKER

Prerequisite - install docker

1. clone down this repository
2. build the container (i.e. docker build . --tag tic_tac_toe)
3. run the container as interactive terminal (i.e. docker run -it tic_tac_toe:latest)


## EXPLANATION OF THOUGHT

HIGH LEVEL - variables are well named leading to easy readability, concerns are well-segregated into separate objects; similarly effort was put in to segregate in-object concerns into separate methods for easy future testing

#### Grid Object

1. class was created with zero references to the game; it stands alone as one might expect, capable of being used for non-tic-tac-toe phenomenon without confusion.

2. grid created uses hash orientation.  Users are not occasioned to thinking of arrays as beginning at zero, they are used to number lists beginning at 1, that was the reason for creating the grid as a hash - user input can be utilized without manipulation.

3. horizontal/vertical/diagonal matches are dynamic, allowing for eventually using a grid larger than 3 squares if desired (though a couple of changes would first need to be made)

Could use a fair amount of refactoring, I get explicit with my iterators when  I'm building but there is certainly opportunity to cut code lines here...

A couple of the method naming conventions could also  be improved upon.

Its probably wise to call grid's 'grid' something different, could confuse a maintainer looking across tic_tac_toe.rb

#### Player Object

Player was created to store 1) the game string (FYI - users CAN play with something other than 'X' or 'O'), 2) to store an ordinal reference to the player that could be used to determine who-goes-next

Yes, the ordinal reference is not really required, it can  be done away... but much like the grid object (choosing  hashes over arrays), I prefer to be explicit with object identification

#### Tic Tac Toe Game

Pretty self-explanatory, is responsible for providing the user information  on how-to-play-the-game.  Contains  little logic in itself, is an interactor which drives most logic from the grid class.  

The tic tac toe game DOES allow you to change the symbols from 'X','O' if you so desire

a change i wont merge
