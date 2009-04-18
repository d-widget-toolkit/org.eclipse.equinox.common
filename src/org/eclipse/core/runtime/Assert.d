/*******************************************************************************
 * Copyright (c) 2000, 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 *
 * Contributors:
 *     IBM Corporation - initial API and implementation
 * Port to the D programming language:
 *     Frank Benoit <benoit@tionex.de>
 *******************************************************************************/
module org.eclipse.core.runtime.Assert;

import org.eclipse.core.runtime.AssertionFailedException;

import java.lang.all;

/**
 * <code>Assert</code> is useful for for embedding runtime sanity checks
 * in code. The predicate methods all test a condition and throw some
 * type of unchecked exception if the condition does not hold.
 * <p>
 * Assertion failure exceptions, like most runtime exceptions, are
 * thrown when something is misbehaving. Assertion failures are invariably
 * unspecified behavior; consequently, clients should never rely on
 * these being thrown (and certainly should not being catching them
 * specifically).
 * </p><p>
 * This class can be used without OSGi running.
 * </p><p>
 * This class is not intended to be instantiated or sub-classed by clients.
 * </p>
 * @since org.eclipse.equinox.common 3.2
 * @noextend This class is not intended to be subclassed by clients.
 * @noinstantiate This class is not intended to be instantiated by clients.
 */
public final class Assert {
    /* This class is not intended to be instantiated. */
    private this() {
        // not allowed
    }

    /** Asserts that an argument is legal. If the given bool is
     * not <code>true</code>, an <code>IllegalArgumentException</code>
     * is thrown.
     *
     * @param expression the outcode of the check
     * @return <code>true</code> if the check passes (does not return
     *    if the check fails)
     * @exception IllegalArgumentException if the legality test failed
     */
    public static bool isLegal(bool expression) {
        return isLegal(expression, ""); //$NON-NLS-1$
    }

    /** Asserts that an argument is legal. If the given bool is
     * not <code>true</code>, an <code>IllegalArgumentException</code>
     * is thrown.
     * The given message is included in that exception, to aid debugging.
     *
     * @param expression the outcode of the check
     * @param message the message to include in the exception
     * @return <code>true</code> if the check passes (does not return
     *    if the check fails)
     * @exception IllegalArgumentException if the legality test failed
     */
    public static bool isLegal(bool expression, String message) {
        if (!expression)
            throw new IllegalArgumentException(message);
        return expression;
    }

    /** Asserts that the given object is not <code>null</code>. If this
     * is not the case, some kind of unchecked exception is thrown.
     *
     * @param object the value to test
     */
    public static void isNotNull(Object object) {
        isNotNull(object, ""); //$NON-NLS-1$
    }
    public static void isNotNull(String str) {
        isTrue(str.ptr !is null); //$NON-NLS-1$
    }
    public static void isNotNull(void* ptr) {
        isTrue(ptr !is null); //$NON-NLS-1$
    }

    /** Asserts that the given object is not <code>null</code>. If this
     * is not the case, some kind of unchecked exception is thrown.
     * The given message is included in that exception, to aid debugging.
     *
     * @param object the value to test
     * @param message the message to include in the exception
     */
    public static void isNotNull(Object object, String message) {
        if (object is null)
            throw new AssertionFailedException("null argument:" ~ message); //$NON-NLS-1$
    }
    public static void isNotNull(String str, String message) {
        isTrue(str.ptr !is null, message ); //$NON-NLS-1$
    }
    public static void isNotNull(void* ptr, String message) {
        isTrue(ptr !is null, message ); //$NON-NLS-1$
    }

    /** Asserts that the given bool is <code>true</code>. If this
     * is not the case, some kind of unchecked exception is thrown.
     *
     * @param expression the outcode of the check
     * @return <code>true</code> if the check passes (does not return
     *    if the check fails)
     */
    public static bool isTrue(bool expression) {
        return isTrue(expression, ""); //$NON-NLS-1$
    }

    /** Asserts that the given bool is <code>true</code>. If this
     * is not the case, some kind of unchecked exception is thrown.
     * The given message is included in that exception, to aid debugging.
     *
     * @param expression the outcode of the check
     * @param message the message to include in the exception
     * @return <code>true</code> if the check passes (does not return
     *    if the check fails)
     */
    public static bool isTrue(bool expression, String message) {
        if (!expression)
            throw new AssertionFailedException("assertion failed: " ~ message); //$NON-NLS-1$
        return expression;
    }
}
