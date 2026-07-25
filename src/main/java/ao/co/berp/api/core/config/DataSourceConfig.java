package ao.co.berp.api.core.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

@Configuration
@Slf4j
public class DataSourceConfig {

    // ============================================
    // PROPRIEDADES DO application.properties
    // ============================================

    @Value("${app.datasource.admin.url}")
    private String adminUrl;

    @Value("${app.datasource.admin.username}")
    private String adminUsername;

    @Value("${app.datasource.admin.password}")
    private String adminPassword;

    @Value("${app.datasource.target-db}")
    private String targetDatabase;

    @Value("${app.datasource.target.host}")
    private String targetHost;

    @Value("${app.datasource.target.port}")
    private String targetPort;

    @Value("${spring.datasource.username}")
    private String datasourceUsername;

    @Value("${spring.datasource.password}")
    private String datasourcePassword;

    @Value("${spring.datasource.hikari.maximum-pool-size:10}")
    private int maxPoolSize;

    @Value("${spring.datasource.hikari.minimum-idle:5}")
    private int minIdle;

    @Value("${spring.datasource.hikari.connection-timeout:30000}")
    private long connectionTimeout;

    @Value("${spring.datasource.hikari.idle-timeout:600000}")
    private long idleTimeout;

    @Value("${spring.datasource.hikari.max-lifetime:1800000}")
    private long maxLifetime;

    @Value("${spring.datasource.hikari.pool-name:HikariPool-BERP}")
    private String poolName;

    @Bean
    @Primary
    public DataSource dataSource() {
        // 🔥 1. Creates the database if it doesn't exist (using the admin URL).
        createDatabaseIfNotExists();

        // 🔥 2. Constructs the final URL using the target database.
        String targetUrl = buildTargetUrl();

        log.info("✅ Setting up DataSource for: {}", targetUrl);

        // 🔥 3. Configure HikariCP with the target database URL.
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(targetUrl);
        config.setUsername(datasourceUsername);
        config.setPassword(datasourcePassword);
        config.setDriverClassName("org.postgresql.Driver");
        config.setPoolName(poolName);
        config.setMaximumPoolSize(maxPoolSize);
        config.setMinimumIdle(minIdle);
        config.setConnectionTimeout(connectionTimeout);
        config.setIdleTimeout(idleTimeout);
        config.setMaxLifetime(maxLifetime);

        // 🔥 4. Additional validation
        config.setConnectionTestQuery("SELECT 1");
        config.setValidationTimeout(5000);

        log.info("✅ DataSource initialized successfully!");
        return new HikariDataSource(config);
    }


    private void createDatabaseIfNotExists() {
        log.info("🔄 Checking if database '{}' exists...", targetDatabase);
        log.info("🔄 Using administrative URL: {}", adminUrl);

        try (Connection connection = DriverManager.getConnection(adminUrl, adminUsername, adminPassword);
             Statement statement = connection.createStatement()) {

            // Checks if the database exists in the PostgreSQL catalog.
            String checkQuery = String.format(
                    "SELECT 1 FROM pg_database WHERE datname = '%s'",
                    targetDatabase
            );

            try (ResultSet resultSet = statement.executeQuery(checkQuery)) {
                if (!resultSet.next()) {
                    // Databas doesn't exist, creating a new one...
                    String createQuery = String.format("CREATE DATABASE %s", targetDatabase);
                    statement.executeUpdate(createQuery);
                    log.info("✅ Database '{}' created successfully.", targetDatabase);
                } else {
                    log.warn("⚠️ Database '{}' already exists.", targetDatabase);
                }
            }
        } catch (Exception e) {
            log.error("❌ Error while checking/creating database '{}': {}", targetDatabase, e.getMessage());
            log.error("❌ Check if the 'postgres' database is accessible at: {}", adminUrl);
            throw new RuntimeException("Failed to initialize database: " + targetDatabase, e);
        }
    }
    /**
     * Constrói a URL final apontando para o banco alvo.
     * Exemplo: jdbc:postgresql://localhost:5433/berp_db
     */
    private String buildTargetUrl() {
        return String.format(
                "jdbc:postgresql://%s:%s/%s",
                targetHost,
                targetPort,
                targetDatabase
        );
    }
}
