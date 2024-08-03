import { useContext, useEffect, useState } from "react";
import { CurrentUserContext } from '../providers/CurrentUser';
import { Steps, StepProps, Alert } from 'antd';
import { StyleSelect, UsernameInput } from "./profile-creation";
import { useNavigate } from "react-router-dom";





interface ErrorAlertProps {
    message: string;
    visible: boolean;
}

function getOverallStatus(statuses: StepProps["status"][]) {
    if (statuses.every((status) => status === "finish")) {
        return "finish";
    } else if (statuses.some((status) => status === "error")) {
        return "error";
    } else {
        return "process";
    }
}

function getCurrentStep(statuses: StepProps["status"][]) {
    // Count consecutive "finish" statuses from the beginning of the array
    let count = 0;
    for (let i = 0; i < statuses.length; i++) {
        if (statuses[i] === "finish") {
            count++;
        } else {
            break;
        }
    }
    if (count === statuses.length) {
        return statuses.length - 1;
    }
    else {
        return count;
    }
}

export default function ProfileCreator() {
    const currentUserContext = useContext(CurrentUserContext);
    const [errorAlert, setErrorAlert] = useState<ErrorAlertProps>({ message: "", visible: false });
    const [usernameStatus, setUsernameStatus] = useState<StepProps["status"]>("process");
    const [avatarStatus, setAvatarStatus] = useState<StepProps["status"]>("process");
    const statuses = [usernameStatus, avatarStatus];
    const overallStatus = getOverallStatus(statuses);
    const currentStepIndex = getCurrentStep(statuses);
    const navigate = useNavigate();

    const setError = (message: string | undefined) => {
        if (message) {
            setErrorAlert({ message: message, visible: true });
        } else {
            setErrorAlert({ message: "", visible: false });
        }
    }

    const steps = [
        {
            title: "Enter Username",
            content: <UsernameInput 
                currentUserContext={currentUserContext} 
                notifyStatus={setUsernameStatus} 
                setError={setError}
            />,
        },
        {
            title: "Select Avatar Style",
            content: <StyleSelect 
                currentUserContext={currentUserContext} 
                notifyStatus={setAvatarStatus}
                setError={setError}
            />,
        }
    ]

    useEffect(() => {
        if (statuses.every((status) => status === "finish")) {
            console.log("All steps complete");
            navigate("/feed");
        }

        
    }, [statuses]);


    return(
        <>
            <Alert style={{
                display: errorAlert.visible ? "block" : "none",
                marginBottom: "1rem"
            }} 
            message={errorAlert.message} 
            type="error" 
            showIcon 
            closable 
            onClose={() => setError(undefined)} 
            />
            <Steps style={{width:"50%", alignSelf:"center"}} current={currentStepIndex} items={steps} status={overallStatus} />
            {steps[currentStepIndex].content}
        </>
        
    )
}