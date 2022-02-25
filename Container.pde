public interface Container {
  
  float x();
  void setX(float x);
  float y();
  void setY(float y);
  float width();
  void setWidth(float w);
  float height();
  float minHeight();
  int size();
  boolean empty();
  int numRows();
  void display();
  
  // Sets whether this Container is allowed to shrink or not.
  // If set to true, then this call may cause height() to change
  // Returns whether height() changes.
  boolean setShrink(boolean s);
  
  // Returns if this Contains is allowed to shrink.
  boolean doesShrink();
  
  // Adds a TierItem nearest the coordinates specified by (x,y)
  // (x,y) is not required to be inside the Container.
  // Returns true if height() changes, false otherwise.
  boolean add(float x, float y, TierItem item);
  
  // Adds a TierItem to the end of the Container.
  // Returns true if height() changes, false otherwise.
  boolean add(TierItem item);
  
  // Adds a new TierItem based on image to the end of the Container.
  // Returns true if height() changes, false otherwise.
  boolean add(PImage image);
  
  // Gets the TierItem nearest the coordinates specified by x,y
  // (x,y) is not required to be inside the Container.
  // Will return null if the Container is empty.
  TierItem get(float x, float y);
  
  // Sets the value of the space occupied by oldItem to newItem.
  // Returns true if successful (i.e, oldItem exists in this Container),
  // false otherwise.
  boolean set(TierItem oldItem, TierItem newItem);
  
  // Sets the value of the space nearest the coordinates specified by x,y to item.
  // (x,y) is not required to be inside the Container.
  // Returns true if successful (i.e. the Container is not empty),
  // false otherwise.
  boolean set(float x, float y, TierItem item);
  
  // Removes the specified TierItem from the Container.
  // May change height() if doesShrink() == true
  // Returns true if height() changes, false otherwise.
  boolean remove(TierItem item);
  
  // Removes the TierItem nearest the coordinates specified by x,y
  // (x,y) is not required to be inside the Container.
  // May change height() if doesShrink() == true
  // Returns true if height() changes, false otherwise.
  boolean remove(float x, float y);
  
  // Returns if the specified point is contained in the Container.
  boolean contains(float x, float y);
  
  // Returns if the specified point is contained in the Container
  // PLUS an extra rectangular ring around the Container.
  boolean contains(float x, float y, float padding);
  
  // Returns if the specified TierItem exists in the Container.
  boolean contains(TierItem item);
  
  // Attempts to shift the specified TierItem that ALREADY EXISTS in
  // the Container to a the space nearest the point specified by x, y.
  // (x,y) is not required to be inside the Container.
  // Returns true if successful (i.e. item exists in the Container),
  // false otherwise.
  boolean shift(TierItem item, float x, float y);
  
}
