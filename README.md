'Green Eggs...' TabBar
------------------------

In the spring of 2013, while learning iOS development and the Cocoa Touch frameworks, I began an app I code-named 'Green Eggs...'.  The app would be for tracking backyard chickens through the eggs they laid. It served as my playground to learn how to write an iOS app.

This repository is the custom Tab Bar I wrote for **'Green Eggs...'**.  It aims to solve the problems that many app developers turned to the 'hamburger menu' to solve. That problem was how to present to the user with more views (UIViewControllers) in their app than can fit on a 5-tab UITabBar (iPhone 4s and 5 era).  The standard TabBar offered the solution of the 5th Tab pushing a TableView with the extra options on it.   This resulted in hiding these options from most users and proved not to be discoverable. 3rd-party developers created the ''The Hamburger and basement' to solve this same problem.  That has since been branded as a place for features to go and die.  I decided I needed a new solution, and my goals were:

* Use simple standard UI concepts that even the most novice iPhone users would recognize.
* Grow with the user if they choose to use the more advanced features.
* Make sure that the more advanced features were just as easy to get to as the novice features.
* Was discoverable.
* Worked well in the case where more advanced features were available via ‘in-app purchase', and could serve to advertise those features without being obnoxious. (The locked/unpurchased features could be discovered without being in the way.)
* One of the tabs must always be visible because no matter where the user was in the app, it was important to be able to tap to add more records. There were more than 10 types of items that could be tracked in the app, and all of them were a tap away from being added.

![screenshot](https://raw.githubusercontent.com/briancordanyoung/Green-Eggs-TabBar/master/Green-Eggs-TabBar.gif)

This **'Green Eggs...' TabBar** attempts to solve this by creating a Tab Bar that presents 5 tabs and can be scrolled to reveal 2 more on each side.  The advantages are:

* At first, it only appears to be a 5-position TabBar, easily recognizable to novicusers.rs. 
* It allows 9 different tabs.
* The other tabs may be accidentally discovered in 2 ways: 
	* Swiping across the tab bar, revealing either side.
	* At the end of a screen rotation, the tabbar can 'bounce' when resting in the new orientation, momentarily showing that there is more to be seen on either side.
* For the advanced users, any of the 9 tabs are just as easy to get to and in context on the overall UI, not hidden in a basement and forgotten.
<!-- * In keeping with the kitschiness of the app I hand a third discovery method planned. When there is very little data to be displayed, a animated illustration of a chicken would be visible behind/undernearth many on the table views in various view controllers on some tabs. The animated chicken would at times when the iphone ideal, peck at the egg, making the whole tabbar slightly shift and bounce back in to place. -->

* The center tab would always be in view, allowing users to add new records at all times.  I also chose to hide the TabBar when rotating to landscape.  But the center 'Add' tab remained in view.

One feature I added to the TabBar was to automatically center itself after a short delay.  After an accidental swipe, providing that the user did not touch one of the far tabs, the TabBar would return to the center and be in a position that a novice user expected.

Other UI considerations were to always maintain feedback to the user so it was clear the iPhone recognized their touch.  I planned for some View Controllers to be heavy to load, *(this was developed on an iPhone 4)* so the tab animates up like an old-time cash register number, only descending after the ViewController is loaded and displaying. ***

And finally, after the iPhone 5, it seemed a future larger-screen iPhone may come, and this tabbar would be able to grow with the added real estate.

Not a pre-packaged control
--------------------------------

Currently, this is posted as an example and prototype of my UI solution.  I have not packaged up the classes into a library or module that could be easily reused.  There is a lot of refactoring I'd like to do to better follow the UITabBar API.  Feel free to take this concept and code and expand on it.  If I ever returned to this project, I would also use auto layout throughout the control.

Notes about the graphic design
--------------------------------
This TabBar was not intended to be a drop-in replacement for UITabBar, but a specialised control for a fun, kitschy app marketed at a user that would appreciate it.  It was first designed for a skeuomorphic iOS 6 design language with all interface elements using a gauche, handpainted look.  It also was adaptable to iOS 7 and beyond because I planned to incorporate visual elements of painting on glass.  This would work well with the translucent look of many iOS 7 views.


** I don't say it is 'standard' because I made the UI customized to this app's painterly and folky graphic design

*** The graphic design was made to be folksy, keeping in theme of many backyard chicken and farming paraphernalia.
