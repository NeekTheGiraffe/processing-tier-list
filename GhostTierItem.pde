class GhostTierItem extends TierItem {
    
  GhostTierItem(TierItem template, Bucket location) {
    super(template.img, location);
  }
  
  void display() {
    tint(255, 127);
    
    image(img, x, y);
  }
}
