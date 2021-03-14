import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LogTest {
    public static void main(String[] args) {
        Logger log = LoggerFactory.getLogger(LogTest.class);

        log.debug("debug消息id={}, name={}", 1, "zhangsan");
        log.info("普通消息");
        log.warn("警告");
        log.error("错误");
    }
}
