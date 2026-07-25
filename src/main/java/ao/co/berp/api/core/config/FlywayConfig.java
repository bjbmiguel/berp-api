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

    @Value("${spring.profiles.active}")
    private String activeProfile;

    @Bean(initMethod = "migrate")
    public Flyway flyway(DataSource dataSource) {
        Flyway flyway = Flyway.configure()
                .dataSource(dataSource)
                .locations("classpath:db/migration")
                .baselineOnMigrate(true)
                .load();

        if ("dev".equals(activeProfile)) {
            log.warn("Running flyway in dev environment...");
            flyway = Flyway.configure()
                    .dataSource(dataSource)
                    .locations("classpath:db/migration", "classpath:db/testdata")
                    .baselineOnMigrate(true)
                    .load();
        }

        return flyway;
    }
}