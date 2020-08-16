# Photoshop Battles
Photoshop Battles is an iOS application that allows users to browse constests from the [r/photoshopbattles](https://www.reddit.com/r/photoshopbattles/). The images are parsed from the comments and fetched using the Reddit and Imgur APIs respectively.

### Core Features
- Discover the latest contests for a selected category.
- Review the submissions for a selected contest.
- Save your favorite contests
- The ability to share a contest with your friends.

### Requirements
- Xcode 11.4
- Swift 5.2

### Installation
1. Download the source code
   ```
   git clone git@github.com:ShaneRich5/photoshop-battles.git
   ```
1. Open the folder Xcode and build the app.


### User Guide

This section assumes you have successfully installed the app.

##### Discovering contests.
1. When the app is first launched, you will be presented with the `Discover` tab containing the latest contests.
   * The order of the contests are determined by the selected category. By default this `hot` posts.
1. To change the category, click the icon in the top right of the screen (the three bars)
1. You will be prompted with the available categories to select.
1. Knowing that the content on the page will become stale during usage, you may pull the table view to refresh the page.

##### Viewing a contest
1. Click a contest you are interested to select it.
1. On the new screen, the selected image will be presented in a larger format with the submissions appear below in a horizonal scrollabel gallery.
1. Click on a submission will replace the main image.
1. The original contest image is always on the far left.

##### Sharing a contest
1. While viewing a contest, you may click the icon with the up arrow.
1. The appropriate user options will appear to allow you to share the Reddit link associated with the contest.

##### Saving a contest
1. While viewing a contest, you may click the `Save` option on the far right of the screen.
1. Clicking it again will override and delete the previously saved contest.
   * This is useful because they may be additional submissions that may be added that you would be able to re-download.
   * **Warning** If a submission was saved as a part of contest and it is deleted from Reddit, resaving the contest will remove it from the saved data.

##### Saved contests
1. From the `Discover` screen, select the `Saved` tab.
1. All the saved contests will be arrange in three column grid managed by a CollectionView.
1. If you have not saved an image, you should select one from the `Discover` tab and repeat `step 3` to save one.
1. Clicking the one of the image will take you to the detail view for the selected contest.
1. Clicking the trash icon on the top right of the page will delete all of the saved contests.
   * At least one contest needs to be saved for the button to be present.
