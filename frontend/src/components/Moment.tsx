import { Button, ButtonGroup } from "flowbite-react";

export default function Moment() {
    return (
        <div className="flex justify-center border">
            <div className="inline-flex space-x-1">
                <div className="">
                    chart here
                </div>
                <div className="flex-row space-y-1">
                    <Button outline>:)</Button>
                    <Button outline>:(</Button>
                </div>
            </div>
        </div>
    );
}