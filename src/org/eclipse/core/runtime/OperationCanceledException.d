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
module org.eclipse.core.runtime.OperationCanceledException;

import java.lang.all;

/**
 * This exception is thrown to blow out of a long-running method
 * when the user cancels it.
 * <p>
 * This class can be used without OSGi running.
 * </p><p>
 * This class is not intended to be subclassed by clients but
 * may be instantiated.
 * </p>
 * @noextend This class is not intended to be subclassed by clients.
 */
public final class OperationCanceledException : RuntimeException {
    /**
     * All serializable objects should have a stable serialVersionUID
     */
    private static const long serialVersionUID = 1L;

    /**
     * Creates a new exception.
     */
    public this() {
        super();
    }

    /**
     * Creates a new exception with the given message.
     *
     * @param message the message for the exception
     */
    public this(String message) {
        super(message);
    }
}
