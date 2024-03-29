/*******************************************************************************
 * Copyright (c) 2008 IBM Corporation and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * 
 * Contributors:
 *     IBM Corporation - initial API and implementation
 *******************************************************************************/
// Port to the D programming language:
//     Frank Benoit <benoit@tionex.de>
module org.eclipse.core.internal.runtimePrintStackUtil;

import java.lang.all;


import java.io.PrintStream;
import java.io.PrintWriter;

import org.eclipse.core.runtime.IStatus;

public class PrintStackUtil {

    static public void printChildren(IStatus status, PrintStream output) {
        IStatus[] children = status.getChildren();
        if (children is null || children.length is 0)
            return;
        for (int i = 0; i < children.length; i++) {
            output.println("Contains: " + children[i].getMessage()); //$NON-NLS-1$
            Throwable exception = children[i].getException();
            if (exception !is null)
                exception.printStackTrace();
            printChildren(children[i], output);
        }
    }

    static public void printChildren(IStatus status, PrintWriter output) {
        IStatus[] children = status.getChildren();
        if (children is null || children.length is 0)
            return;
        for (int i = 0; i < children.length; i++) {
            output.println("Contains: " + children[i].getMessage()); //$NON-NLS-1$
            output.flush(); // call to synchronize output
            Throwable exception = children[i].getException();
            if (exception !is null)
                exception.printStackTrace();
            printChildren(children[i], output);
        }
    }

}
