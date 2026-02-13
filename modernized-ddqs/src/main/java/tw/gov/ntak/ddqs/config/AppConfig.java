package tw.gov.ntak.ddqs.config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public final class AppConfig {
    private static final Properties PROPS = new Properties();

    static {
        try (InputStream is = AppConfig.class.getClassLoader().getResourceAsStream("application.properties")) {
            if (is == null) {
                throw new IllegalStateException("application.properties not found");
            }
            PROPS.load(is);
        } catch (IOException ex) {
            throw new IllegalStateException("failed to load application.properties", ex);
        }
    }

    private AppConfig() {
    }

    public static String get(String key) {
        return PROPS.getProperty(key);
    }

    public static int getInt(String key, int defaultValue) {
        String v = PROPS.getProperty(key);
        return v == null ? defaultValue : Integer.parseInt(v);
    }
}
