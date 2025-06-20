package gov.municipal.it.cms.util;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.atomic.AtomicInteger;

public class ComplaintIdGenerator {
    private static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyyMMdd-HHmmss");
    private static final AtomicInteger sequence = new AtomicInteger(0);
    private static String lastTimestamp = "";

    public static synchronized String generateComplaintId() {
        String now = DATE_FORMAT.format(new Date());

        if (!now.equals(lastTimestamp)) {
            sequence.set(0);
            lastTimestamp = now;
        }

        int seq = sequence.getAndIncrement();
        if (seq > 99) {
            sequence.set(0);
            seq = sequence.getAndIncrement();
        }

        String seqStr = String.format("%02d", seq);

        return now + "-" + seqStr;
    }
}
