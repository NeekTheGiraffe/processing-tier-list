class NonTierBucket extends Bucket {
  
  NonTierBucket() {
    bucketX = TIER_MARGIN;
    bucketWidth = width - TIER_MARGIN - bucketX;
    itemsPerRow = bucketWidth / TIER_ITEM_SIZE;
    updateBucketHeight();
  }
  
  void display() {
    rectMode(CORNER);
    rect(bucketX, bucketY, bucketWidth, bucketHeight);
  }
  
}
