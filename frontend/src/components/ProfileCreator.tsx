import { Card, Carousel } from "flowbite-react";
import { createAvatar, Style, schema } from '@dicebear/core';
import { toPng, Result } from "@dicebear/converter";
import * as collection from '@dicebear/collection';
import { useEffect, useState } from "react";

interface StyleOptionProps {
    index: number;
    image: Result;
    imageAlt: string;
    style: string;
    selected: boolean;
    onClick: () => void;
}

function StyleOption(props: StyleOptionProps) {
    const hasBorder = props.selected ? "border-2 border-blue-500" : "";
    const [png, setPng] = useState<string | undefined>(undefined);


    useEffect(() => {
        props.image.toDataUri().then((dataUri) => {
            setPng(dataUri);
        })
        .catch((error) => {
            console.error(error);
        })
    }, [props.image]);

    return (
        <img 
            key={props.index} 
            src={png} 
            alt={props.imageAlt} 
            className={`rounded-lg w-24 h-24 ${hasBorder}`} 
            onClick={props.onClick} 
            title={props.style}
        />
    )
}

interface StyleSelectProps {
    handleSelectedStyle: (style: string) => void;
}

function StyleSelect(props: StyleSelectProps) {
    const [selectedStyleIndex, setSelectedStyleIndex] = useState(-1);

    const handleSelectedStyle = (index: number, name: string) => {
        setSelectedStyleIndex(index);
        props.handleSelectedStyle(name);
    }

    const styles = Object.keys(collection).map((styleName, index) => {
        let style = collection[styleName as keyof typeof collection];
        let exampleAvatar = createAvatar(style as Style<{ seed: String; }>, { seed: "Glimmr" });

        return {
            index: index,
            image: toPng(exampleAvatar.toString()),
            imageAlt: styleName,
            style: styleName,
            selected: selectedStyleIndex === index,
            onClick: () => { handleSelectedStyle(index, styleName) }
        }
    });

    return (
        <div className="grid grid-cols-4 gap-2">
            {styles.map((style) => <StyleOption key={style.index} {...style} />)}
        </div>          
    )
}



interface RemainingStepsProps {
    styleName: string;
}

function RemainingSteps(props: RemainingStepsProps) {
    const style = collection[props.styleName as keyof typeof collection];

    const options = {
        ...style.schema.properties
    }

    useEffect(() => {
        console.log(options);
    }, [options]);

    return(
        <></>
    )
}

export default function ProfileCreator() {
    const [selectedStyle, setSelectedStyle] = useState<string | undefined>(undefined);

    return(
        <>
            
            <StyleSelect handleSelectedStyle={setSelectedStyle} />
            {
                selectedStyle &&
                <RemainingSteps styleName={selectedStyle} />
            }
        </>
    )
}