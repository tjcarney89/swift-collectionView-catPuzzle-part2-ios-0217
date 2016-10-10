# Cat Pic Puzzle - Collection Views

![snapshot](https://s3.amazonaws.com/learn-verified/cat-puzzle-snapshot.png)

## Objectives
1. Build a picture game using a collection view controller
2. Become familiar with data handling, view layout, and subclassing reusable views
3. Determine the game winning sequence to trigger a segue and modally present another view controller

# Part 2

### 1. Add Supplementary Views to the Collection View

Each section of a collection view has the option of including supplementary views (header and/or footer) of type `UICollectionReusableView`.

 * Add two variable properties on the `CollectionViewController` class:
  * `var headerReusableView: HeaderReusableView!`
  * `var footerReusableView: FooterReusableView!`
 * Add the following code snippet inside `viewDidLoad()` of the `CollectionViewController` class:

```swift

self.collectionView?.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
self.collectionView?.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")

```
 * Add the following data source method below the existing data source methods in the `CollectionViewController` class:

```swift

override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

   if kind == UICollectionElementKindSectionHeader {

       headerReusableView = (self.collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)) as! HeaderReusableView

       return headerReusableView

   } else {

       footerReusableView = (self.collectionView?.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath)) as! FooterReusableView

       return footerReusableView
   }

}

```

There have been two subclasses created for you in this project that inherit from `UICollectionReusableView`, `HeaderReusableView` and `FooterReusableView`. These classes are being used programmatically in the project (i.e., not in storyboard). The method call used in `viewDidLoad` called `register(_:forSupplementaryViewOfKind:withIdentifier:)` registers the class with the collection view. The data source method, `collectionView(_:viewForSupplementaryElementOfKind:at:)`, asks the data source object to provide the subclassed supplementary views to the collection view.

### 2. Configure the Layout

If you run the project you will not see any changes to the layout from part 1. Even though the header and footer views are included, they lack size. In fact, so far the only size information for the collection view is coming from default settings in interface builder. Let's change that.

 * Inside the `CollectionViewController` class, declare a method called `configureLayout()` that takes no arguments and has no return. Call this method inside `viewDidLoad()`.
 * Add the following variable properties to the `CollectionViewController` class:
  * `var sectionInsets: UIEdgeInsets!`
  * `var spacing: CGFloat!`
  * `var itemSize: CGSize!`
  * `var referenceSize: CGSize!`
  * `var numberOfRows: CGFloat!`
  * `var numberOfColumns: CGFloat!`

The goal for the `configureLayout()` method is to set up all the dimensions for the various reusable views and spaces around them in the collection view. Once the dimensions are calculated, the values should be assigned to the appropriate properties you just declared.

**IMPORTANT:** This particular grid layout should fit all the reusable views (items(cells), header, footer) inside the dimensions of the screen. The header should be at the top, then the items should form a 3x4 grid, and then the footer should be at the bottom.

Before you begin calculating dimensions, you will need to update the `CollectionViewController` class to adhere to the `UICollectionViewDelegateFlowLayout` protocol. This will allow you to add the delegate methods necessary to provide the collection view with layout information.

 * Update your `CollectionViewController` class declaration to include adherence to `UICollectionViewDelegateFlowLayout`
 * Add the following methods to the `CollectionViewController` class:
  * `collectionView(_:layout:minimumLineSpacingForSectionAt:)` _return_ `spacing`
  * `collectionView(_:layout:minimumInteritemSpacingForSectionAt:)` _return_ `spacing`
  * `collectionView(_:layout:insetForSectionAt:)` _return_ `sectionInsets`
  * `collectionView(_:layout:sizeForItemAt:)` _return_ `itemSize`
  * `collectionView(_:layout:referenceSizeForHeaderInSection:)` _return_ `referenceSize`
  * `collectionView(_:layout:referenceSizeForFooterInSection:)` _return_ `referenceSize`

If you try to run the application, it will crash. Since the properties related to the layout were declared as implicitly unwrapped optionals, they don't have any values yet. Those properties must have values before the flow layout methods are called. That's what the `configureLayout()` method is for and why it's called in `viewDidLoad()`. Let's define the dimensions inside `configureLayout()`.

 * Declare two variables for the width and height of the screen (_Hint:_ `UIScreen.main.bounds...`).
 * Assign a value of `4` to `numberOfRows`.
 * Assign a value of `3` to `numberOfColumns`.
 * Assign a value of `2` to `spacing` (The `spacing` value will be used for section insets, minimum interitem spacing, and minimum line spacing).
 * Assign a value to `sectionInsets` using the `UIEdgeInsets` initializer (top, bottom, left, and right should all equal `spacing`).
 * Assign a value to `referenceSize` using the `CGSize` initializer (use the initializer that takes `CGFloat`). The width should be the width of the screen and the height should be `60`.

The last layout dimension you need is the size for each item (cell) in the collection view. The item size is dependent on screen size, the numbers of rows/columns, and the space being used around each item (e.g., section insets, item spacing, line spacing, header/footer size).

 * Using variables and calculations as needed, determine the item width. You will need to divide the screen width by the number of columns. You will also need to subtract an equal portion of the total amount of space being taken up by left/right insets and item spacing.
 * Using variables and calculations as needed, determine the item height. You will need to divide the screen height by the number of rows. You will also need to subtract an equal portion of the total amount of space being taken up by top/bottom insets, line spacing, and header/footer height.
 * Assign a value to `itemSize` using the the `CGSize` initializer (use the initializer that takes `CGFloat`). Use the item width and height you calculated as your arguments.
 * Build and run the application. There should be 12 cat pictures taking up most of the screen with an equal amount of space on top and bottom for the header and the footer.

### 3. Provide Data to the Collection View

The collection view is currently using a static number, 12, for the number of items and the same picture for each cell. Let's provide an actual collection of data for the collection view. The assets folder has 12 picture slices to use in the collection view.

 * Declare and initialize a variable property called `imageSlices` that is an array of type `UIImage`.
 * Inside `viewDidLoad()` of the `CollectionViewController` class, use a for loop with a range to populate the `imageSlices` array with the images from the assets folder (images 1 through 12).
 * Update `numberOfItems(inSection:)` to return the count of the `imageSlices` array.
 * Update `collectionView(_:cellForItemAt:)` to grab an image from the `imageSlices` array instead of the same image it's currently using.
 * Build and run the application. You should see all the image slices in order making up a completed picture.

### 4. Add a Reordering Method to `CollectionViewController`

When you use a `UICollectionViewController` it's simple to add the option to reorder cells. By calling another data source method, the collection view will allow items to be reordered. There's animation built in too. You may notice it's difficult to move cells at first. Since this is a starter approach to reordering cells, there is no control over the gesture used on the cells. The cells require a long press before they begin to move.

 * Add the data source method `collectionView(_:moveItemAt:to:)` to the `CollectionViewController` class. Simply by overriding the method, the option to reorder cells is "turned on" therefore the body of the method can be left empty.
 * Build and run the application. You should be able to move cells to different locations within the collection view.

### 5. Randomize the `imageSlices` array

 * Write a function to randomize the `imageSlices` array _after_ it's initially populated in `viewDidLoad()`.
 * Build and run the application to see if your randomizer is working.

## Advanced

There are a handful of other steps you can take to treat this even more like a game. Here's some hints to take this even further:

 * The `FooterReusableView` class has a timer and timer related functions. How could you incorporate those into the `CollectionViewController` class? Remember you have the `footerReusableView` property that is of type `FooterReusableView`. `FooterReusableView` has useful properties/methods like `startTimer()`, `timer`, and `timerLabel`.
 * How can you tell once a user has moved all the image slices back into order to complete the picture? `collectionView(_:moveItemAt:to:)` supplies you with the source index path and the destination index path when a cell is being moved. This information allows you the option to reorder the `imageSlices` array. Here's a code snippet you can add _**inside**_ of `collectionView(_:moveItemAt:to:)` to help you out:

```swift

self.collectionView?.performBatchUpdates({

  // reorder the imageSlices array here


  }, completion: { completed in

      // 1. Check for winning scenario
      // 2. Invalidate the timer
      // 3. Perform segue with identifier "solvedSegue"

})

```
 * There is a segue set up in `Main.storyboard` to a second view controller called `SolvedViewController`. Use `prepare(for:sender:)` to segue to `SolvedViewController`. In the prepare for segue method, assign values to the properties of `SolvedViewController` named `image` and `time`. `image` should be the `cats` image in the assets folder. `time` should be the value of `footerReusableView.timerLabel.text` (the current time at the moment the puzzle was solved).
