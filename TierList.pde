public class TierList {
  
  private final Tier[] _tiers;
  private final Bucket _baseBucket;
  
  private final float _x, _y, _w;
  
  public TierList(float x, float y, float w)
  {
    _x = x;
    _y = y;
    _w = w;
    _tiers = new Tier[6];
    
    float baseBucketY = _createDefaultTiers(); 
    _baseBucket = new Bucket(_x, baseBucketY, _w, TierItem.LENGTH);
  }
  
  public float height() {
    float h = 0;
    for (Tier tier : _tiers) {
      h += tier.height() + Tier.MARGIN;
    }
    h += _baseBucket.height();
    return h;
  }
  
  public boolean doesShrink() { return _baseBucket.doesShrink(); }
  public boolean setShrink(boolean s) {
    boolean changedHeight = false;
    for (Tier t : _tiers) {
      if (t.setShrink(s)) changedHeight = true;
    }
    if (_baseBucket.setShrink(s)) changedHeight = true;
    if (changedHeight) _adjustPositions();
    return changedHeight;
  }
  
  public void add(PImage img) {
    _baseBucket.add(img);
  }
  
  // Gets the TierItem located closest to the given position
  public TierItem getNearest(float x, float y) {
    // Do a linear search of all tiers
    for (Tier tier : _tiers) {
      if (!tier.contains(x, y, Tier.MARGIN)) continue;
      return tier.get(x, y);
    }
    // Check the base bucket
    return _baseBucket.get(x, y);
  }
  
  public TierItem get(float x, float y) {
    // Do a linear search of all tiers
    for (Tier tier : _tiers) {
      if (!tier.bucketContains(x, y)) continue;
      return tier.get(x, y);
    }
    // Check the base bucket
    if (!_baseBucket.contains(x, y)) return null;
    return _baseBucket.get(x, y);
  }
  
  // Replaces the value of the TierItem reference belonging to
  // the specified coordinates with the given item.
  public boolean set(float x, float y, TierItem item) {
    for (Tier tier : _tiers) {
      if (!tier.bucketContains(x, y)) continue;
      return tier.set(x, y, item);
    }
    if (!_baseBucket.contains(x, y)) return false;
    return _baseBucket.set(x, y, item);
  }
  
  // Replaces the value of the reference containing oldItem
  // with a reference to newItem
  public boolean set(TierItem oldItem, TierItem newItem) {
    return set(oldItem.x(), oldItem.y(), newItem);
  }
  
  // Adjusts the location and position of item
  // based on the given coordinates x, y
  public void adjust(TierItem item, float x, float y) {
    
    Container oldContainer = _tierOf(item);
    Container newContainer = _tierOf(x, y, Tier.MARGIN);
    
    //println("oldContainer=" + oldContainer + ", newContainer=" + newContainer);
    if (oldContainer == null || newContainer == null) return;
    
    // Check if tier matches
    if (oldContainer != newContainer) {
      // Tier doesn't match
      boolean hChanged = false;
      if (oldContainer.remove(item)) hChanged = true;
      if (newContainer.add(x, y, item)) hChanged = true;
      if (hChanged) _adjustPositions();
      return;
    }
    
    // Tier matches
    oldContainer.shift(item, x, y);
  }
  
  public void display() {
    for (Tier tier : _tiers) tier.display();
    _baseBucket.display();
  }
  
  //
  // ---- Private methods ----
  //
  
  private void _adjustPositions() {
    float y = _y;
    for (int i = 0; i < _tiers.length; i++) {
      _tiers[i].setY(y);
      y += _tiers[i].height() + Tier.MARGIN;
    }
    _baseBucket.setY(y);
  }
  
  private Container _tierOf(float x, float y, float padding) {
    for (Tier t : _tiers) {
      if (t.contains(x, y, padding)) {
        return t;
      }
    }
    if (_baseBucket.contains(x, y, Tier.MARGIN)) return _baseBucket;
    return null;
  }
  private Container _tierOf(TierItem item) {
    for (Tier t : _tiers) {
      if (t.contains(item)) {
        return t;
      }
    }
    if (_baseBucket.contains(item)) return _baseBucket;
    return null;
  }
  
  private float _createDefaultTiers()
  {  
    String[] names = new String[] { "S", "A", "B", "C", "D", "F" };
    color[] colors = new color[] {
      color(245, 41, 0),  color(245, 147, 0),
      color(245, 200, 0), color(104, 201, 0),
      color(6, 112, 212), color(87, 0, 217) };
    
    float y = _y;
    for (int i = 0; i < _tiers.length; i++) {
      _tiers[i] = new Tier(names[i], colors[i], _x, y, _w, TierItem.LENGTH);
      y += TierItem.LENGTH + Tier.MARGIN;
    }
    return y;
  }
}
