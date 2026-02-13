package tw.gov.ntak.ddqs;

import org.junit.Assert;
import org.junit.Test;
import tw.gov.ntak.ddqs.config.AppConfig;

public class AppConfigTest {
    @Test
    public void shouldLoadProperties() {
        Assert.assertNotNull(AppConfig.get("mariadb.host"));
    }
}
