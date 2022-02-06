import java.util.ArrayList;
import java.io.File;

final int TIER_MARGIN = 20;
final int TIER_LABEL_SIZE = 100;
final int TIER_ITEM_SIZE = 100;
final int TEXT_OFFSET = 15;
final int WIDTH = 1000;

PFont f;

String path = "C:/Users/npavl/Desktop/TierListMaker Resources/pasta";
File imageDir = new File(path);
String[] imageList = imageDir.list();

TierItem dragged;
int ghostIndex;
NonTierBucket ntb;
GhostTierItem ghostDragged;

ArrayList<Bucket> tiers = new ArrayList<Bucket>();

void settings() {
  size(WIDTH, 1000);
}

void setup() {
  f = createFont("Arial", 16, true);
  textFont(f, 36);
  
  surface.setTitle("Tier List Maker");
  surface.setResizable(true);
  
  ntb = new NonTierBucket();
  tiers.add(ntb);
  addTier("S", 245, 41, 0);
  addTier("A", 245, 147, 0);
  addTier("B", 245, 200, 0);
  addTier("C", 104, 201, 0);
  addTier("D", 6, 112, 212);
  addTier("F", 87, 0, 217);
  for (String imageName : imageList) {
    ntb.addItemFromImage(loadImage(path + "/" + imageName));
  }
  ntb.setY(getBucketYByIndex(tiers.size()));
  ntb.updateBucketHeight();
  
  updateAllContentsPositions();
}

void draw() {
  background(200);
  
  int h = getHeight();
  if (height != h) surface.setSize(WIDTH, h);
  for (Bucket tier : tiers) {
    tier.display();
  }
  for (Bucket tier : tiers) {
    tier.displayContents();
  }
  if (dragged != null) dragged.display();
  
}

/*MOUSE CONTROLS*/

void mouseDragged() {
  //If dragged doesn't exist, try to create dragged and ghostDragged.
  if (dragged == null) {
    for (Bucket tier : tiers) {
      for (int i = 0; i < tier.getSize(); i++) {
        TierItem item = tier.getItem(i);
        if (item.mouseInside()) {
          dragged = item;
          ghostIndex = i;
          
          ghostDragged = new GhostTierItem(dragged, tier);
          tier.setItem(i, ghostDragged);
          tier.updateContentsPositions();
        }
      }
    }
  //If dragged already exists...
  } else {
    //Update position of dragged based on mouse
    dragged.setPosition(mouseX - (TIER_ITEM_SIZE / 2), mouseY - (TIER_ITEM_SIZE / 2));
    
    
    Bucket dBucket = findTierFromPosition(dragged);
    //If TIER doesn't match dragged, switch tier.
    if (dBucket != ghostDragged.getLocation()) {
      int newIndex = findIndexFromPosition(dragged, dBucket, 1);
      
      ghostDragged.getLocation().removeItem(ghostIndex);
      dBucket.addItem(newIndex, ghostDragged);
      ghostDragged.setLocation(dBucket);
      ghostIndex = newIndex;
      
      updateTierSizesNoShrink();
      updateAllContentsPositions();
      
    } else {
      
      //If INDEX doesn't match dragged, switch index.
      int newIndex = findIndexFromPosition(dragged, dBucket);
      if (newIndex != ghostIndex) {
        dBucket.removeItem(ghostIndex);
        dBucket.addItem(newIndex, ghostDragged);
        ghostIndex = newIndex;
        
        updateAllContentsPositions();
      }
    }
    
  }
}

void mouseReleased() {
  if (dragged != null) {
    
    //Determine new tier for dragged object
    Bucket newTier = ghostDragged.getLocation();
    
    //Write the new tier to the console
    if (newTier instanceof Tier) {
      Tier tier = (Tier)newTier;
      print(tier.name);
    } else {
      print("No tier");
    }
    println(", " + ghostIndex);
    
    newTier.setItem(ghostIndex, dragged);  //Replace the ghost object with the dragged object
    dragged.setLocation(newTier);          //Set the location of the dragged object
    dragged = null;                        //Clear the dragged and ghostDragged fields
    ghostDragged = null;
    
    //Re-render the interface
    updateTierSizes();
    updateAllContentsPositions();
  }
}

/*STATIC METHODS*/

void addTier(String name, int r, int g, int b) {
  tiers.add(new Tier(name, r, g, b));
}


//Finds and removes a tier item from all tiers
void removeTierItem(TierItem item) {
  for (Bucket tier : tiers) {
    for (int i = 0; i < tier.getSize(); i++) {
      if (tier.getItem(i) == item) {
        tier.removeItem(i);
        return;
      }
    }
  }
}

int getBucketYByIndex(int index) {
  if (index > tiers.size()) return -1;
  int y = TIER_MARGIN;
  for (int i = 0; i < index; i++) {
    if (!(tiers.get(i) instanceof Tier)) {
      continue;
    } else {
      y += TIER_MARGIN;
      y += tiers.get(i).getBucketHeight();
    }
  }
  return y;
}

Bucket findTierFromPosition(TierItem item) {
  float testY = item.getY() + TIER_ITEM_SIZE / 2;
  for (Bucket tier : tiers) {
    if (testY > tier.getBucketY() && testY < tier.getBucketY() + tier.getBucketHeight()) {
      return tier;
    }
  }
  return item.getLocation();
}

//Checks a bucket for a particular item, and returns the index it should go in based on its X and Y coords
int findIndexFromPosition(TierItem item, Bucket bucket) {
  return findIndexFromPosition(item, bucket, 0);
}

//The "add" parameter pretends that the tier has a different size than it currently has.
//For example, if you want to insert something into a tier, then you can prematurely calculate
//its position by using findIndexFromPosition(item, bucket, 1).
int findIndexFromPosition(TierItem item, Bucket bucket, int add) {
  float testX = item.getX() + TIER_ITEM_SIZE / 2;
  float testY = item.getY() + TIER_ITEM_SIZE / 2;
  int numItems = bucket.getSize() + add;
  int itemsPerRow = bucket.getItemsPerRow();
  int numRows = (numItems - 1)/itemsPerRow + 1; //Number of rows in bucket
  for (int i = 0; i < numItems; i++) {
    int currentX = bucket.getContentsXByIndex(i);
    int currentY = bucket.getContentsYByIndex(i);
    if (!(i / itemsPerRow == 0) && testY < currentY) { //Min y check; top row exempt
      //println("i=" + i + " failed MIN Y");
      continue;
    }
    if (!(i / itemsPerRow == numRows - 1) && testY > currentY + TIER_ITEM_SIZE) { //Max y check; bottom row exempt
      //println("i=" + i + " failed MAX Y");
      continue;
    }
    if (!(i % itemsPerRow == 0) && testX < currentX) { //Min x check; left column exempt
      //println("i=" + i + " failed MIN X");
      continue;
    }
    if (!(i % itemsPerRow == itemsPerRow - 1 || i == numItems - 1) && testX > currentX + TIER_ITEM_SIZE) { //Max x check; right column exempt
      //println("i=" + i + " failed MAX X");
      continue;
    }
    return i;  // Item is properly placed; return index.
  }
  return -1;
}

int getHeight() {
  int h = TIER_MARGIN;
  for (Bucket tier : tiers) {
    h += tier.getBucketHeight();
    h += TIER_MARGIN;
  }
  return h;
}

void updateTierSizes() {
  for (int i = 1; i <= tiers.size(); i++) {
    tiers.get(i % tiers.size()).setY(getBucketYByIndex(i));
    tiers.get(i % tiers.size()).updateBucketHeight();
  }
}

void updateTierSizesNoShrink() {
  for (int i = 1; i <= tiers.size(); i++) {
    tiers.get(i % tiers.size()).setY(getBucketYByIndex(i));
    tiers.get(i % tiers.size()).updateBucketHeightNoShrink();
  }
}

void updateAllContentsPositions() {
  for (Bucket tier : tiers) {
    tier.updateContentsPositions();
  }
}
