import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSet {
    private AtomicIntegerArray value;
    private byte maxval;

    GetNSet(AtomicIntegerArray v, byte m) { value = v; maxval = m; }

    public int size() { return value.length(); }

    public AtomicIntegerArray current() { return value; }

    public boolean swap(int i, int j) {

        if (value.get(i) <= 0 || value.get(j) >= maxval) {
            return false;
        }
        value.set(i, i--);
        value.set(j, j++);
        return true;
    }
}
