package com.memora.app.support;

import java.lang.reflect.Constructor;
import java.lang.reflect.RecordComponent;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public final class RecordFixtureFactory {

    private RecordFixtureFactory() {
    }

    public static <T> T createRecord(final Class<T> type) {
        if (!type.isRecord()) {
            throw new IllegalArgumentException(type.getName() + " is not a record type.");
        }
        return type.cast(createValue(type, new HashSet<>()));
    }

    private static Object createValue(final Class<?> type, final Set<Class<?>> visited) {
        if (type == String.class) {
            return "value";
        }
        if (type == Long.class || type == long.class) {
            return 1L;
        }
        if (type == Integer.class || type == int.class) {
            return 1;
        }
        if (type == Boolean.class || type == boolean.class) {
            return true;
        }
        if (type == Double.class || type == double.class) {
            return 1.0d;
        }
        if (type == Float.class || type == float.class) {
            return 1.0f;
        }
        if (type == Short.class || type == short.class) {
            return (short) 1;
        }
        if (type == Byte.class || type == byte.class) {
            return (byte) 1;
        }
        if (type == Character.class || type == char.class) {
            return 'a';
        }
        if (type == OffsetDateTime.class) {
            return OffsetDateTime.parse("2026-01-01T00:00:00Z");
        }
        if (type == Instant.class) {
            return Instant.parse("2026-01-01T00:00:00Z");
        }
        if (type == LocalDate.class) {
            return LocalDate.parse("2026-01-01");
        }
        if (type == LocalDateTime.class) {
            return LocalDateTime.parse("2026-01-01T00:00:00");
        }
        if (List.class.isAssignableFrom(type)) {
            return List.of();
        }
        if (Set.class.isAssignableFrom(type)) {
            return Set.of();
        }
        if (Map.class.isAssignableFrom(type)) {
            return Map.of();
        }
        if (type.isEnum()) {
            final Object[] constants = type.getEnumConstants();
            if (constants.length == 0) {
                throw new IllegalArgumentException("Enum " + type.getName() + " has no constants.");
            }
            return constants[0];
        }
        if (!type.isRecord()) {
            throw new IllegalArgumentException("Unsupported fixture type: " + type.getName());
        }
        if (!visited.add(type)) {
            return null;
        }

        try {
            final RecordComponent[] components = type.getRecordComponents();
            final Class<?>[] parameterTypes = new Class<?>[components.length];
            final Object[] arguments = new Object[components.length];
            for (int index = 0; index < components.length; index++) {
                parameterTypes[index] = components[index].getType();
                arguments[index] = createValue(parameterTypes[index], visited);
            }
            final Constructor<?> constructor = type.getDeclaredConstructor(parameterTypes);
            return constructor.newInstance(arguments);
        } catch (ReflectiveOperationException exception) {
            throw new IllegalStateException("Failed to create fixture for " + type.getName(), exception);
        } finally {
            visited.remove(type);
        }
    }
}
