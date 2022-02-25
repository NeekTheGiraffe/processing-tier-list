import java.util.List;
import java.util.ArrayList;
import java.lang.StringBuilder;
import java.lang.Math;

public class Bucket implements Container {
  
  private float _x, _y, _w, _h;
  private boolean _shrink;
  
  private final float _minHeight;
  private final List<TierItem> contents;
  
  public Bucket(float x, float y, float w, float minHeight)
  {
    contents = new ArrayList<TierItem>();
    _x = x;
    _y = y;
    _w = w;
    _minHeight = minHeight;
    _h = minHeight;
    _shrink = true;
  }
  
  @Override public float x() { return _x; }
  @Override public void setX(float x) { _x = x; _adjustPositions(); }
  @Override public float y() { return _y; }
  @Override public void setY(float y) { _y = y; _adjustPositions(); }
  @Override public float width() { return _w; }
  @Override public void setWidth(float w) { _w = w; _adjustPositions(); }
  @Override public float height() { return _h; }
  @Override public float minHeight() { return _minHeight; }
  @Override public int size() { return contents.size(); }
  @Override public boolean empty() { return contents.size() == 0; }
  @Override public boolean setShrink(boolean s) { _shrink = s; return (s) ? _adjustHeight() : false; }
  @Override public boolean doesShrink() { return _shrink; }
  
  @Override
  public boolean add(TierItem item)
  {
    // Set item to proper position
    item.setPosition(_xOf(size()), _yOf(size()));
    
    contents.add(item);
    
    if (size() % _itemsPerRow() == 1) return _adjustHeight();
    return false;
  }
  @Override
  public boolean add(float x, float y, TierItem item)
  {
    int i = _indexOf(x, y, 1); // Calculate with an extra slot
    
    contents.add(i, item);
    _adjustPositions(i);
    
    if (size() % _itemsPerRow() == 1) return _adjustHeight();
    return false;
  }
  @Override
  public boolean add(PImage image)
  {
    // Calculate the proper position of the item
    TierItem item = new TierItem(_xOf(size()), _yOf(size()), image);
    
    // Add the item
    contents.add(item);
    
    if (size() % _itemsPerRow() == 1) return _adjustHeight();
    return false;
  }
  @Override
  public TierItem get(float x, float y) {
    int i = _indexOf(x,y);
    if (i == -1) return null; // This Bucket is empty
    return contents.get(i);
  }
  
  @Override
  public boolean set(TierItem oldItem, TierItem newItem) {
    int i = _indexOf(oldItem);
    if (i == -1 || contents.get(i) != oldItem) return false;
    
    newItem.setPosition(_xOf(i), _yOf(i));
    contents.set(i, newItem);
    
    return true;
  }
  @Override
  public boolean set(float x, float y, TierItem item) {
    int i = _indexOf(x, y);
    if (i < 0) return false;
    
    item.setPosition(_xOf(i), _yOf(i));
    contents.set(i, item);
    
    return true;
  }
  @Override
  public boolean remove(TierItem item) {
    int i = _indexOf(item);
    if (i == -1 || contents.get(i) != item) return false;
    
    contents.remove(i);
    _adjustPositions(i);
    
    if (_shrink && size() % _itemsPerRow() == 0) {
      return _adjustHeight();
    }
    return false;
  }
  @Override
  public boolean remove(float x, float y) {
    int i = _indexOf(x, y);
    if (i == -1) return false;
    
    contents.remove(i);
    _adjustPositions(i);
    
    if (_shrink && size() % _itemsPerRow() == 0) {
      return _adjustHeight();
    }
    return false;
  }
  
  // Returns the number of rows of TierItems there are in this bucket
  @Override
  public int numRows() {
    return (size() - 1) / _itemsPerRow() + 1;
  }
  
  @Override public boolean contains(float x, float y) { return contains(x, y, 0f); }
  @Override
  public boolean contains(float x, float y, float padding) {
    if (x < _x - padding || x > _x + _w + padding) return false;
    if (y < _y - padding || y > _y + _h + padding) return false;
    return true;
  }
  @Override
  public boolean contains(TierItem item) {
    if (!contains(item.x(), item.y())) return false;
    return contents.get(_indexOf(item.x(), item.y())) == item;
  }
  
  @Override
  public boolean shift(TierItem item, float x, float y)
  {
    int i1 = _indexOf(item);
    if (i1 == -1 || contents.get(i1) != item) return false; // item is not in this Bucket
    int i2 = _indexOf(x, y);
    _shift(i1, i2);
    return true;
  }
  
  // Displays this Bucket
  @Override
  public void display() {
    
    // Draw this bucket
    rectMode(CORNER);
    fill(70);
    stroke(0);
    strokeWeight(1);
    rect(_x, _y, _w, _h);
    
    // Draw all items inside
    for (TierItem item : contents) item.display();
  }
  
  @Override
  public String toString() {
    StringBuilder bld = new StringBuilder();
    bld.append("Bucket{x=").append(_x).append(", y=").append(_y);
    // bld.append(", contents=").append(contents);
    bld.append('}');
    return bld.toString();
  }
  
  //
  // ---- Private methods ----
  //
  
  // Returns the index that an x, y coordinate "belongs" to
  // based on the positioning of items in this Bucket.
  private int _indexOf(float x, float y) { return _indexOf(x, y, 0); }
  private int _indexOf(float x, float y, int extraSlots) {
    int numItems = size() + extraSlots;
    int numRows = (numItems - 1) / _itemsPerRow() + 1;
    int numColumns = Math.min(numItems, _itemsPerRow());
    
    int column = _calcFromEquallySpacedGroups(x, _x, TierItem.LENGTH, numColumns);
    int row = _calcFromEquallySpacedGroups(y, _y, TierItem.LENGTH, numRows);
    
    int index = row * _itemsPerRow() + column;
    if (numItems - 1 < index) index = numItems - 1;
    
    return index;
  }
  private int _indexOf(TierItem item) {
    if (!contains(item.x(), item.y())) return -1;
    return _indexOf(item.x(), item.y());
  }
  // Calculates the "index" of the group that an item belongs to
  private int _calcFromEquallySpacedGroups(float testVal, float startVal, float spacing, int numGroups) {
    if (testVal < startVal) {
      return 0;
    } else if (testVal > startVal + numGroups * spacing) {
      return numGroups - 1;
    }
    return (int)(testVal - startVal) / (int)spacing;
  }
  
  // Returns the proper x value of a TierItem in the specified index
  private float _xOf(int i) { return _x + TierItem.LENGTH * (i % _itemsPerRow()); }
  
  // Returns the proper y value of a TierItem in the specified index
  private float _yOf(int i) { return _y + TierItem.LENGTH * (i / _itemsPerRow()); }
  
  // Returns the proper number of items per row.
  private int _itemsPerRow() { return (int)_w / TierItem.LENGTH; }
  
  // Adjusts the positions of the TierItems stored in this Bucket to their
  // proper locations.
  private void _adjustPositions() { _adjustPositions(0); }
  private void _adjustPositions(int begin) {
    for (int i = begin; i < contents.size(); i++) { 
      contents.get(i).setPosition(_xOf(i), _yOf(i));
    }
  }
  
  // Adjusts the height to match the number of items in this bucket
  private boolean _adjustHeight() {
    
    float hi = (float)numRows() * TierItem.LENGTH;
    hi = Math.max(hi, _minHeight); // hi gets the maximum of hi and minHeight
    
    // Don't bother if heights are equal
    if (hi == _h) return false;
    
    _h = hi;
    return true;
  }
  
  // The item in i1 will "jump" to i2, and the items in between
  // will shift to accomodate this jump.
  private void _shift(int i1, int i2) {
    if (i1 == i2) return;
    if (i1 > i2) {
      // Shift right
      TierItem ti = contents.get(i1);
      for (int i = i1; i > i2; i--) {
        TierItem left = contents.get(i - 1);
        left.setPosition(_xOf(i), _yOf(i));
        contents.set(i, left);
      }
      contents.set(i2, ti);
      ti.setPosition(_xOf(i2), _yOf(i2));
      return;
      
    }
    // i1 < i2, so shift left
    TierItem item = contents.get(i1);
    for (int i = i1; i < i2; i++) {
      TierItem right = contents.get(i + 1);
      right.setPosition(_xOf(i), _yOf(i));
      contents.set(i, right);
    }
    contents.set(i2, item);
    item.setPosition(_xOf(i2), _yOf(i2));
  }
}
