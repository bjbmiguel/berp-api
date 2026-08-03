package ao.co.berp.api.core.enums;

import lombok.Getter;

/*
 * Mapping of Nodes for TSID generation.
 * Each table has a unique node (0-1023) to ensure unique and organized IDs.
 * Node 0 is reserved for general use/not mapped.
 * @see ao.co.berp.api.core.service.TsidGenerator
 */
@Getter
public enum TableNode {

    // ============================================
    // TABELAS DO SISTEMA (1-10)
    // ============================================
    PARTY(1, "party", "Companies/Organizations"),
    USERS(2, "users", "System users"),
    PERSON(3, "person", "Individuals"),
    COUNTRY(4, "country", "Countries"),
    ACCESS_ROLE(5, "access_role", "Access profiles"),
    PROVINCE(6, "province", "Province"),
    MUNICIPALITY(7, "municipality", "Municipalities"),
    COMMUNE(8, "commune", "Communes");


    private final int nodeId;
    private final String tableName;
    private final String description;

    TableNode(int nodeId, String tableName, String description) {
        this.nodeId = nodeId;
        this.tableName = tableName;
        this.description = description;
    }

    public static TableNode fromTableName(String tableName) {
        for (TableNode node : TableNode.values()) {
            if (node.tableName.equals(tableName)) {
                return node;
            }
        }
        throw new IllegalArgumentException("Unknown table: " + tableName);
    }


    public static TableNode fromNodeId(int nodeId) {
        for (TableNode node : TableNode.values()) {
            if (node.nodeId == nodeId) {
                return node;
            }
        }
        throw new IllegalArgumentException("Unknown node ID: " + nodeId);
    }


    public static boolean existsForTable(String tableName) {
        try {
            fromTableName(tableName);
            return true;
        } catch (IllegalArgumentException e) {
            return false;
        }
    }
}