package ao.co.berp.api.core.config;

import lombok.extern.slf4j.Slf4j;
import org.flywaydb.core.Flyway;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

@Configuration
@Slf4j
public class FlywayConfig {

    private static final String DEV_PROFILE = "dev";
    private static final String MIGRATION_LOCATION = "classpath:db/migration";
    private static final String SEED_LOCATION = "classpath:db/seeds";
    private static final String TEST_DATA_LOCATION = "classpath:db/testdata";

    @Value("${spring.profiles.active}")
    private String activeProfile;

    @Bean(initMethod = "migrate")
    public Flyway flyway(DataSource dataSource) {

        String[] locations = isDevelopmentProfile()
                ? new String[]{
                MIGRATION_LOCATION,
                SEED_LOCATION,
                TEST_DATA_LOCATION
        }
                : new String[]{
                MIGRATION_LOCATION,
                SEED_LOCATION
        };

        return Flyway.configure()
                .dataSource(dataSource)
                .locations(locations)
                .baselineOnMigrate(true)
                .load();
    }

    private boolean isDevelopmentProfile() {
        return DEV_PROFILE.equalsIgnoreCase(activeProfile);
    }
}