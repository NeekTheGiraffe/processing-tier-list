public class Tier extends ForwardingContainer {
  
  public static final int MARGIN = 20;
  
  private final String _name;
  private final color _col;
  
  private float _x, _y, _w;
  
  public Tier(String name, color c, float x, float y, float w, float minHeight)
  {
    super(new Bucket(x + minHeight + MARGIN, y, w - minHeight - MARGIN, minHeight));
    _x = x;
    _y = y;
    _w = w;
    _col = c;
    _name = name;
  }
  
  @Override public float x() { return _x; }
  @Override public void setX(float x) { _x = x; super.setX(_bucketX()); }
  @Override public float y() { return _y; }
  @Override public void setY(float y) { _y = y; super.setY(_y); }
  @Override public float width() { return _w; }
  @Override public void setWidth(float w) { _w = w; super.setWidth(_bucketW()); }
  
  @Override
  public void display() {
    
    // Draw the tier box
    stroke(0);
    strokeWeight(1);
    rectMode(CORNER);
    fill(_col);
    rect(_x, _y, minHeight(), height());
    
    // Bucket
    super.display();
    
    // Tier letter
    textAlign(CENTER);
    if (red(_col) + green(_col) + blue(_col) > 600) fill(0);
    else fill(255);
    text(_name, _x + 0.5*minHeight(), _y + 0.5*height() + 0.5*textAscent());
  }
  
  @Override public boolean contains(float x, float y) { return contains(x, y, 0f); }
  @Override public boolean contains(float x, float y, float padding) {
    if (x < _x - padding || x > _x + _w + padding) return false;
    if (y < _y - padding || y > _y + height() + padding) return false;
    return true;
  }
  
  @Override
  public String toString() {
    StringBuilder bld = new StringBuilder();
    return bld.append("Tier{name=").append(_name).append('}').toString();
  }
  
  //
  // ---- Encapsulated methods ----
  //
  
  public boolean bucketContains(float x, float y) { return super.contains(x, y); }
  public boolean bucketContains(float x, float y, float padding) { return super.contains(x, y, padding); }
  
  //
  // ---- Private methods ----
  //
  
  private float _bucketX() { return _x + minHeight() + MARGIN; }
  private float _bucketW() { return _w - minHeight() - MARGIN; }
}
