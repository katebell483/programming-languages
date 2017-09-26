import java.util.concurrent.atomic.AtomicReference;
import java.util.concurrent.locks.ReentrantLock;
import java.util.concurrent.locks.StampedLock;


public class BetterSafeState implements State {
    private byte[] value;
    private byte maxval;
    private StampedLock lock = new StampedLock();

    BetterSafeState(byte[] v) {
        value = v;
        maxval = 127;
    }

    BetterSafeState(byte[] v, byte m) {
        value = v;
        maxval = m;
    }

    public int size() { return value.length; }

    public byte[] current() {
        return value;
    }

    public boolean swap(int i, int j) {

        boolean stillSpinning = false;

        // loop until write is successfully completed
        while(stillSpinning) {

            // get optimistic read
            long stamp = lock.tryOptimisticRead();

            try {

                // make sure they are legit
                if (value[i] <= 0 || value[j] >= maxval) {
                    return false;
                }

                // try to convert optimistic read to write lock
                if(lock.tryConvertToWriteLock(stamp) != 0) {

                    // increment/decrement values
                    value[i]--;
                    value[j]++;

                    //exit out of loop
                    stillSpinning = false;
                }

            } finally {
                // always release lock
                lock.tryUnlockWrite();
            }
        }
        return true;

    }

}
