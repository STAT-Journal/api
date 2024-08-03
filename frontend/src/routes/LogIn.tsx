import { Button, Input } from "antd"
import { useState } from "react";
import { useOutlet } from "react-router-dom";
import { graphql }  from '../gql/codegen';
import { useMutation } from "urql";

interface emailState {
    email: string;
    validationResult?: boolean;
    color: string;
    helperText?: string;
}

interface toastState {
    hidden: boolean;
    message: string;
    color: string;
}

export function LogIn() {
    const [emailState, setEmailState] = useState<emailState>({ email: "", color: "default" });
    const [toastState, setToastState] = useState<toastState>({ hidden: true, message: "", color: "default" });
    const outlet = useOutlet();

    const setEmail = (email: string) => {
        let oldState = emailState
        setEmailState({ ...oldState, email: email });
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

    const mutation = graphql(`mutation registerWithEmail($email: String!) {\n  register(email: $email)\n}`);
    const [_, executeMutation] = useMutation(mutation);

    function loginWithEmail(email: string) {
  
        return executeMutation({ email: email })
        .then((result) => {
            if (result.error) {
                let errors = result.error.graphQLErrors.join(", ");
                setToastState({ hidden: false, message: `Error logging in: ${errors}`, color: "failure" });
            }
            if (result.data?.register) {
                let register = result.data?.register;
                setToastState({ hidden: false, message: register, color: "success" });
            }
        });
    }
    
    function validateEmail(email: string) {
        return email.length == 0 ? undefined : /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)
    }


    return (
        <div className="flex-row space-y-2">
            <Input 
                id="email" 
                type="email"
                placeholder="name@email.com" 
                required 
                color={emailState.color}
                onChange={(e) => setEmail(e.target.value)}
                onBlur={(e) => setEmailValidation(e.target.value)}
            />
            <Button onClick={() => loginWithEmail(emailState.email)}>Sign in with email</Button>
            <div className="text-center">
                Enter your email and we'll send you a link to sign in.
            </div>
            {outlet}
        </div>
    )
}