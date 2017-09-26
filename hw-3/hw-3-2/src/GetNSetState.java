import java.util.concurrent.atomic.AtomicIntegerArray;

class GetNSetState implements State {
    private byte[] value;
    private byte maxval;
    private AtomicIntegerArray atomicIntArray;

    GetNSetState(byte[] v) {
        value = v;
        maxval = 127;
        atomicIntArray = convertToAtomicIntArray(value);
    }

    GetNSetState(byte[] v, byte m) {
        value = v;
        maxval = m;
        atomicIntArray = convertToAtomicIntArray(value);
    }

    public int size() { return value.length; }

    public byte[] current() {
        return convertToByteArray(atomicIntArray);
    }

    public boolean swap(int i, int j) {

        if (atomicIntArray.get(i) <= 0 || atomicIntArray.get(j) >= maxval) {
            return false;
        }

        atomicIntArray.set(i, atomicIntArray.get(i) - 1);
        atomicIntArray.set(j, atomicIntArray.get(j) + 1);
        return true;
    }

    private AtomicIntegerArray convertToAtomicIntArray(byte[] input) {
        int[] intArray = new int[input.length];
        for (int i = 0; i < input.length; i++) {
            intArray[i] = input[i];
        }
        return new AtomicIntegerArray(intArray);
    }

    private byte[] convertToByteArray(AtomicIntegerArray input) {
        byte[] byteArray = new byte[input.length()];
        for (int i = 0; i < input.length(); i++) {
            byteArray[i] = (byte) input.get(i);
        }
        return byteArray;
    }
}
