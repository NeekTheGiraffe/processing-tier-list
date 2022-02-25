public abstract class ForwardingContainer implements Container {
  
  private final Container c;
  
  public ForwardingContainer(Container container) {
    c = container;
  }
  
  @Override public float x() { return c.x(); }
  @Override public void setX(float x) { c.setX(x); }
  @Override public float y() { return c.y(); }
  @Override public void setY(float y) { c.setY(y); }
  @Override public float width() { return c.width(); }
  @Override public void setWidth(float w) { c.setWidth(w); }
  @Override public float height() { return c.height(); }
  @Override public float minHeight() { return c.minHeight(); }
  @Override public int size() { return c.size(); }
  @Override public boolean empty() { return c.empty(); }
  @Override public boolean setShrink(boolean s) { return c.setShrink(s); }
  @Override public boolean doesShrink() { return c.doesShrink(); }
  
  @Override public boolean add(TierItem item) { return c.add(item); }
  @Override public boolean add(float x, float y, TierItem item) { return c.add(x, y, item); }
  @Override public boolean add(PImage image) { return c.add(image); }
  @Override public TierItem get(float x, float y) { return c.get(x, y); }
  @Override public boolean set(TierItem oldItem, TierItem newItem) { return c.set(oldItem, newItem); }
  @Override public boolean set(float x, float y, TierItem item) { return c.set(x, y, item); }
  @Override public boolean remove(TierItem item) { return c.remove(item); }
  @Override public boolean remove(float x, float y) { return c.remove(x, y); }
  @Override public boolean contains(float x, float y) { return c.contains(x, y); }
  @Override public boolean contains(float x, float y, float padding) { return c.contains(x, y, padding); }
  @Override public boolean contains(TierItem item) { return c.contains(item); }
  @Override public boolean shift(TierItem item, float x, float y) { return c.shift(item, x, y); }
  @Override public int numRows() { return c.numRows(); }
  @Override public void display() { c.display(); }
}
