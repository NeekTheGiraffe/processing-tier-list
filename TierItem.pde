class TierItem {
  
  float x, y;
  PImage img;
  Bucket location;
  
  TierItem(PImage img, Bucket location) {
    this.img = img;
    this.img.resize(TIER_ITEM_SIZE, TIER_ITEM_SIZE);
    this.setPosition(0, 0);
    this.location = location;
  }
  
  float getX() {
    return x;
  }
  
  float getY() {
    return y;
  }
  
  void setPosition(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  Bucket getLocation() {
    return location;
  }
  
  void setLocation(Bucket location) {
    this.location = location;
  }
  
  PImage getImg() {
    return img;
  }
  
  boolean mouseInside() {
    if (mouseX > x && mouseX < x + TIER_ITEM_SIZE && mouseY > y && mouseY < y + TIER_ITEM_SIZE) return true;
    return false;
  }
  
  void display() {
    
    if ((dragged == this) || (dragged == null && this.mouseInside() && mousePressed)) {
      tint(100);
    } else if (dragged == null && this.mouseInside()) {
      tint(150);
    } else {
      noTint();
    }
    
    image(img, x, y);
  }
  
}
