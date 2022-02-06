class Tier extends Bucket {
  
  String name;
  int r,g,b;
  
  int labelX;
  int labelY;
  int labelWidth;
  int labelHeight;
  //int bucketX;
  //int bucketY;
  //int bucketWidth;
  //int bucketHeight;
  int textX;
  int textY;
  int textOffset;
  //int itemsPerRow;
  
  Tier(String name, int r, int g, int b) {
    this.name = name;
    this.r = r;
    this.g = g;
    this.b = b;
    
    textOffset = TEXT_OFFSET;                        //How far down to move the text for it to look pretty
    labelX = TIER_MARGIN;                            //X of the top left corner of the tier label (where the letter goes)
    labelWidth = TIER_LABEL_SIZE;                    //Side length of the tier label
    bucketX = TIER_MARGIN * 2 + TIER_LABEL_SIZE;     //X of the top left corner of the bucket (where tier items go)
    bucketWidth = width - TIER_MARGIN - bucketX;     //Width of the bucket
    itemsPerRow = bucketWidth / TIER_ITEM_SIZE;      //The number of tier items that can fit into one row
    textX = labelX + labelWidth / 2;                 //X position of tier letter
    
    setY(getBucketYByIndex(tiers.size()));
    updateBucketHeight();
  }
  
  void setY(int y) {
    bucketY = y;                                     //Y of the top left corner of the bucket
    labelY = y;                                      //Y of the top left corner of the tier label
  }
  
  void updateTextY() {
    textY = labelY + labelHeight / 2 + textOffset;   //Y position of tier letter
  }
  
  void updateBucketHeight() {
    super.updateBucketHeight();
    labelHeight = bucketHeight;
    updateTextY();
  }
  
  void updateBucketHeightNoShrink() {
    super.updateBucketHeightNoShrink();
    labelHeight = bucketHeight;
    updateTextY();
  }
  
  void display() {
    rectMode(CORNER);
    fill(r, g, b);
    rect(labelX, labelY, labelWidth, labelHeight);
    
    fill(70);
    rect(bucketX, bucketY, bucketWidth, bucketHeight);
    
    textAlign(CENTER);
    if (r + g + b > 600) fill(0);
    else fill(255);
    text(this.name, textX, textY);
  }
}
