import { Button, Label, TextInput, Toast } from "flowbite-react"
import { useState } from "react";

interface emailState {
    email: string;
    validationResult?: boolean;
    color: string;
    helperText?: string;
}

interface emailSubmitSuccessResult {
    message: string;
}

interface emailSubmitErrorResult {
    error: string;
}

type emailSubmitResult = emailSubmitSuccessResult | emailSubmitErrorResult;

interface toastState {
    hidden: boolean;
    message: string;
    color: string;
}

function validateEmail(email: string) {
    return email.length == 0 ? undefined : /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
}

export function LogIn() {
    const [emailState, setEmailState] = useState<emailState>({ email: "", color: "default" });
    const [toastState, setToastState] = useState<toastState>({ hidden: true, message: "", color: "default" });

    const setEmail = (email: string) => {
        let oldState = emailState
        setEmailState({ ...oldState, email: email });
        console.log(emailState);
    }

    const setEmailValidation = (email: string) => {
        let validationResult = validateEmail(email);
        let oldState = emailState;
        setEmailState({ ...oldState, 
            validationResult: validationResult, 
            color: validationResult == undefined ? "default" : validationResult ? "success" : "failure",
            helperText: validationResult == undefined ? undefined : validationResult ? "" : "Invalid email"
        });
    }

    const handleSubmit = () => {
        if (emailState.validationResult) {
            fetch("/api/auth/sendEmail", {
                method: "POST",
                headers: {
                    "Accept": "application/json",
                    "Content-Type": "application/json",
                },
                body: JSON.stringify({ email: emailState.email })
            })
            .then((response) => response.json())
            .then((result: emailSubmitResult) => {
                if ("message" in result) {
                    console.log(result.message);
                    setToastState({ hidden: false, message: result.message, color: "success" });
                } else {
                    console.log(result.error);
                    setToastState({ hidden: false, message: result.error, color: "error" });
                }
            })
            .catch((error) => {
                console.log(`Error sending email: ${error.message}`);
                setToastState({ hidden: false, message: `Error getting response from server: ${error.message}`, color: "error" });
            });
        }
    }


    return (
        <div className="flex-row space-y-2">
            <Label htmlFor="email">Email</Label>
            <TextInput 
                id="email" 
                type="email"
                placeholder="name@email.com" 
                required 
                color={emailState.color}
                helperText={emailState.helperText}
                onChange={(e) => setEmail(e.target.value)}
                onBlur={(e) => setEmailValidation(e.target.value)}
            />
            <Button onClick={handleSubmit}>Sign in with email</Button>
            <div className="text-center">
                Enter your email and we'll send you a link to sign in.
            </div>
            <div style={{ display: toastState.hidden ? "none" : "block" }}>
                <Toast {...toastState}>{toastState.message}</Toast>
            </div>
        </div>
    )
}