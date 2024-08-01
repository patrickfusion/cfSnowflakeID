/**
 * Generates a unique Snowflake ID
 *
 * @author Patrick Flynn
 */

component accessors="true" {

    // Constants
    property name="NODE_ID_BITS" type="numeric" default="10";
    property name="SEQUENCE_BITS" type="numeric" default="12";
    property name="DEFAULT_CUSTOM_EPOCH" type="numeric" default="1420070400000"; // Sample default, please for your need

    // Max values
    property name="maxNodeId" type="numeric";
    property name="maxSequence" type="numeric";

    // Variables
    property name="nodeId" type="numeric";
    property name="customEpoch" type="numeric";
    property name="lastTimestamp" type="numeric" default="-1";
    property name="sequence" type="numeric" default="0";

    // Constructor
    public any function init(numeric nodeId=0, numeric customEpoch=DEFAULT_CUSTOM_EPOCH) {

        variables.maxNodeId = (2 ^ variables.NODE_ID_BITS - 1);
        variables.maxSequence = (2 ^ variables.SEQUENCE_BITS - 1);

        if (nodeId < 0 or nodeId > variables.maxNodeId) {
            throw(type="Application", message="NodeId must be between 0 and " & variables.maxNodeId);
        }
        variables.nodeId = nodeId;
        variables.customEpoch = customEpoch;
        return this;
    }

    // Create Snowflake ID
    public string function nextId() {
        lock name="snowflakeLock" type="exclusive" timeout="10" {
            var currentTimestamp = timestamp();

            if (currentTimestamp < variables.lastTimestamp) {
                throw(type="Application", message="Invalid System Clock!");
            }

            if (currentTimestamp == variables.lastTimestamp) {
                variables.sequence = (variables.sequence + 1) & variables.maxSequence;
                if (variables.sequence == 0) {
                    // Sequence Exhausted, wait till next millisecond
                    currentTimestamp = waitNextMillis(currentTimestamp);
                }
            } else {
                // Reset sequence to start with zero for the next millisecond
                variables.sequence = 0;
            }

            variables.lastTimestamp = currentTimestamp;

            // Use Java's BigInteger for bitwise operations
            var BigInteger = createObject("java", "java.math.BigInteger");
            var timestampPart = BigInteger.valueOf(currentTimestamp).shiftLeft(variables.NODE_ID_BITS + variables.SEQUENCE_BITS);
            var nodeIdPart = BigInteger.valueOf(variables.nodeId).shiftLeft(variables.SEQUENCE_BITS);
            var sequencePart = BigInteger.valueOf(variables.sequence);

            var id = timestampPart.or(nodeIdPart).or(sequencePart);

            // Return the ID as a string to ensure it maintains its value
            return id.toString();
        }
    }

    // Get current timestamp in milliseconds, adjust for the custom epoch
    private numeric function timestamp() {
        return getTickCount() - variables.customEpoch;
    }

    // Block and wait till next millisecond
    private numeric function waitNextMillis(numeric currentTimestamp) {
        while (currentTimestamp == variables.lastTimestamp) {
            currentTimestamp = timestamp();
        }
        return currentTimestamp;
    }

    // Parse Snowflake ID
    public array function parse(string id) {
        var BigInteger = createObject("java", "java.math.BigInteger");
        var bigId = BigInteger.init(id);

        var shiftedNodeId = BigInteger.valueOf(1).shiftLeft(variables.NODE_ID_BITS).subtract(BigInteger.ONE);
        var maskNodeId = shiftedNodeId.shiftLeft(variables.SEQUENCE_BITS);
        var maskSequence = BigInteger.valueOf(1).shiftLeft(variables.SEQUENCE_BITS).subtract(BigInteger.ONE);

        var timestamp = bigId.shiftRight(variables.NODE_ID_BITS + variables.SEQUENCE_BITS).longValue() + variables.customEpoch;
        var nodeId = bigId.and(maskNodeId).shiftRight(variables.SEQUENCE_BITS).longValue();
        var sequence = bigId.and(maskSequence).longValue();

        return [timestamp, nodeId, sequence];
    }

    // ToString method for Snowflake settings
    public string function toString() {
        return "Snowflake Settings [NODE_ID_BITS=" & variables.NODE_ID_BITS & ", SEQUENCE_BITS=" & variables.SEQUENCE_BITS & ", CUSTOM_EPOCH=" & variables.customEpoch & ", NodeId=" & variables.nodeId & "]";
    }
}
