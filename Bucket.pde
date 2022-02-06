abstract class Bucket {
  
  int bucketX;
  int bucketY;
  int bucketWidth;
  int bucketHeight;
  int itemsPerRow;
  ArrayList<TierItem> contents = new ArrayList<TierItem>();
  
  void updateContentsPositions() {
    for (int i = 0; i < contents.size(); i++) {
      int imageX = bucketX + TIER_ITEM_SIZE * (i % itemsPerRow);
      int imageY = bucketY + TIER_ITEM_SIZE * (i / itemsPerRow);
      contents.get(i).setPosition(imageX, imageY);
    }
  }
  
  int getBucketY() {
    return bucketY;
  }
  
  int getBucketHeight() {
    return bucketHeight;
  }
  
  int getItemsPerRow() {
    return itemsPerRow;
  }
  
  int getSize() {
    return contents.size();
  }
  
  TierItem getItem(int i) {
    return contents.get(i);
  }
  
  void addItem(TierItem item) {
    contents.add(item);
  }
  
  void addItem(int i, TierItem item) {
    contents.add(i, item);
  }
  
  void addItemFromImage(PImage img) {
    TierItem item = new TierItem(img, this);
    contents.add(item);
  }
  
  void setItem(int i, TierItem item) {
    contents.set(i, item);
  }
  
  void removeItem(int i) {
    contents.remove(i);
  }
  
  int getContentsXByIndex(int i) {
    return bucketX + TIER_ITEM_SIZE * (i % itemsPerRow);
  }
  
  int getContentsYByIndex(int i) {
    return bucketY + TIER_ITEM_SIZE * (i / itemsPerRow);
  }
  
  void updateBucketHeight() {
    if (contents.size() == 0) bucketHeight = TIER_LABEL_SIZE;
    else bucketHeight = ((contents.size() - 1) / itemsPerRow + 1) * TIER_ITEM_SIZE;
  }
  
  void updateBucketHeightNoShrink() {
    int bh;
    if (contents.size() == 0) bh = TIER_LABEL_SIZE;
    else bh = ((contents.size() - 1) / itemsPerRow + 1) * TIER_ITEM_SIZE;
    if (bh > bucketHeight) bucketHeight = bh;
  }
  
  void setY(int y) {
    bucketY = y;
  }
  
  void display() {};
  
  void displayContents() {
    for (TierItem item : contents) {
      if (item != dragged) item.display();
    }
  }
}
