import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.StampedLock;

public class BetterSorryState implements State{
    private byte[] value;
    private byte maxval;
    private StampedLock lock = new StampedLock();

    BetterSorryState(byte[] v) {
        value = v;
        maxval = 127;
    }

    BetterSorryState(byte[] v, byte m) {
        value = v;
        maxval = m;
    }

    public int size() { return value.length; }

    public byte[] current() {
        return value;
    }

    public boolean swap(int i, int j) {

        // assume don't need read
        long stampRead = lock.tryOptimisticRead();

        // read values from byte array
        int valI = value[i];
        int valJ = value[j];

        // validate stamp to make sure nothing has changed
        if (!lock.validate(stampRead)) {

            // if it has changed do read again with read lock
            stampRead = lock.readLock();

            // get values in locked mode
            try {
                valI = value[i];
                valJ = value[j];

                // always release lock
            } finally {
                lock.unlockRead(stampRead);
            }
        }

        // do the comparison
        if (valI <= 0 || valJ >= maxval) {
            return false;
        }

        // always lock for writes
        long stampWrite = lock.writeLock();

        // get values in locked mode
        try {
            value[i]--;
            value[j]++;

            // always release lockin
        } finally {
            lock.unlockWrite(stampWrite);
        }
        return true;
    }

}
